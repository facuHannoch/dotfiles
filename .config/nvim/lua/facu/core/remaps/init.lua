require("facu.core.remaps.ai-remaps")
require("facu.core.remaps.code-remaps")
require("facu.core.remaps.navigation-remaps")
require("facu.core.remaps.ui-remaps")


local wk = require("which-key")
wk.add({
	{ "<leader>u", group = "UI" },
	{ "<leader>n", group = "Navigation" },
	{ "<leader>c", group = "Code" },
})

--
--
-- ==== Copy / Paste Functionality ==== --

-- ­ƒôï Clipboard keymaps (cross-mode, WSL/macOS/Linux compatible)
-- Assumes system clipboard provider is working

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Ôø│ Leader-based versions (for consistency and fallback)
map({ "n", "v" }, "<leader>uc", '"+y', opts) -- Copy
map({ "n", "v" }, "<leader>ux", '"+d', opts) -- Cut
map({ "n", "v" }, "<leader>uv", '"+p', opts) -- Paste

-- ­ƒºá Ctrl-based mappings ÔÇö consistent across modes
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
