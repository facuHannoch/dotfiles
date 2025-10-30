local keymap = vim.keymap

-- Navigation
-- keymap.set("n", "<leader>nv", vim.cmd.Ex, { desc = "Open Explorer" })
vim.keymap.set("n", "<leader>nv", "<cmd>Oil<CR>", { desc = "Open current directory" })
keymap.set("n", "<leader>nb", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>nff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>nfg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>nfb", builtin.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>nfh", builtin.help_tags, { desc = "Help tags" })

-- UI
vim.keymap.set("n", "<leader>un", function()
	vim.opt.relativenumber = not vim.wo.relativenumber
end, { desc = "Toggle relative line numbers" })

-- Code
keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format file" })
keymap.set("n", "<leader>cc", function()
	require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment" })

keymap.set(
	"v",
	"<leader>cc",
	"<ESC><CMD>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
	{ desc = "Toggle comment (visual)" }
)

local wk = require("which-key")
wk.add({
	{ "<leader>u", group = "UI" },
	{ "<leader>n", group = "Navigation" },
	{ "<leader>c", group = "Code" },
})

--
--
-- ==== Copy / Paste Functionality ==== --

-- 📋 Clipboard keymaps (cross-mode, WSL/macOS/Linux compatible)
-- Assumes system clipboard provider is working

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ⛳ Leader-based versions (for consistency and fallback)
map({ "n", "v" }, "<leader>uc", '"+y', opts) -- Copy
map({ "n", "v" }, "<leader>ux", '"+d', opts) -- Cut
map({ "n", "v" }, "<leader>uv", '"+p', opts) -- Paste

-- 🧠 Ctrl-based mappings — consistent across modes
-- Normal / Visual: direct operation
map({ "n", "v" }, "<C-c>", '"+y', opts)
map({ "n", "v" }, "<C-x>", '"+d', opts)
map({ "n", "v" }, "<C-v>", '"+p', opts)

-- Insert mode: leave insert, paste, re-enter insert
map("i", "<C-v>", '<Esc>"+pa', opts)
-- Optional: Ctrl-c/x in insert mode copy/cut current line
map("i", "<C-c>", '<Esc>"+yyA', opts)
map("i", "<C-x>", '<Esc>"+ddA', opts)

-- Custom commands
map("n", "<leader>ur", [[:%d | 0put +<CR>]], opts)

--
--
-- ==== Undo / Redo Functionality ==== --
-- Disable the default suspend keybinding (<C-z>)
vim.api.nvim_set_keymap("n", "<C-z>", "<nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-z>", "<nop>", { noremap = true, silent = true })

-- Normal mode Undo/Redo like VSCode
map("n", "<C-z>", "u", opts) -- Ctrl+Z to undo
map("n", "<A-z>", "<C-r>", opts) -- Alt+Z for redo

vim.keymap.set("n", "<C-A-z>", "<Cmd>stop<CR>", opts)
-- (`:stop` in Vim/Neovim is equivalent to suspending itself.)



--
--
-- Autosave
vim.keymap.set("n", "<leader>ua", ":ToggleAutosave<CR>", { desc = "Toggle autosave" })

-- Smart Select All / Increment

vim.keymap.set("n", "<C-a>", function()
	local col = vim.fn.col(".")
	local line = vim.fn.getline(".")
	local before = line:sub(1, col - 1)
	local after = line:sub(col)

	-- Detect if cursor is on or just before a number
	if before:match("%d$") or after:match("^%d") then
		return "<C-a>" -- increment number (use default)
	else
		return "ggVG" -- select all
	end
end, { noremap = true, silent = true, expr = true })

-- Insert mode version (exit insert -> run same logic -> re-enter visual)
vim.keymap.set("i", "<C-a>", function()
	vim.cmd("stopinsert")
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-a>", true, false, true), "n", false)
end, opts)
