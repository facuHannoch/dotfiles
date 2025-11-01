-- TODO: rename wx to wq ??

-- Navigation
-- keymap.set("n", "<leader>nv", vim.cmd.Ex, { desc = "Open Explorer" })
vim.keymap.set("n", "<leader>nv", "<cmd>Oil<CR>", { desc = "Open current directory" })

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>nff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>nfF", function()
	builtin.find_files({ hidden = true })
end, { desc = "Find hidden files" })
vim.keymap.set("n", "<leader>nfg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>nfb", builtin.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>nfh", builtin.help_tags, { desc = "Help tags" })
-- keymap("n", "<leader>nfp", builtin.git_files, { desc = "Find git files" })
-- keymap("n", "<leader>nfo", builtin.oldfiles, { desc = "Find recent files" })

--
--
-- lua/facu/core/layout-remaps.lua
local keymap = vim.keymap.set
local builtin = require("telescope.builtin")

-- 1️⃣ NAVIGATION (leader>n)
-- Windows
keymap("n", "<leader>nwh", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<leader>nwj", "<C-w>j", { desc = "Move to lower window" })
keymap("n", "<leader>nwk", "<C-w>k", { desc = "Move to upper window" })
keymap("n", "<leader>nwl", "<C-w>l", { desc = "Move to right window" })
keymap("n", "<leader>nwa", "<C-w>p", { desc = "Alternate window" })

-- Buffers
keymap("n", "<leader>nbn", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "<leader>nbp", ":bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "<leader>nba", ":b#<CR>", { desc = "Alternate buffer" })
keymap("n", "<leader>nbl", builtin.buffers, { desc = "List buffers" })

-- Tabs
keymap("n", "<leader>ntn", ":tabnext<CR>", { desc = "Next tab" })
keymap("n", "<leader>ntp", ":tabprevious<CR>", { desc = "Previous tab" })
keymap("n", "<leader>ntl", ":tabs<CR>", { desc = "List tabs" })

-- 2️⃣ MODIFICATION (leader>w / b / t)
--
-- Windows
-- Split current buffer
keymap("n", "<leader>wv", ":vsplit<CR>", { desc = "Vertical split" })
keymap("n", "<leader>wh", ":split<CR>", { desc = "Horizontal split" })

-- Split + new buffer
keymap("n", "<leader>wV", ":vsplit | enew<CR>", { desc = "Vertical split with new buffer" })
keymap("n", "<leader>wH", ":split | enew<CR>", { desc = "Horizontal split with new buffer" })

-- Split + open file under cursor
keymap("n", "<leader>wfv", "<cmd>vertical wincmd f<CR>", { desc = "Open file under cursor in vertical split" })
keymap("n", "<leader>wfh", "<cmd>wincmd f<CR>", { desc = "Open file under cursor in horizontal split" })

--
-- Window management
keymap("n", "<leader>wx", ":close<CR>", { desc = "Close window" })
keymap("n", "<leader>w=", ":wincmd =<CR>", { desc = "Equalize windows" })
-- keymap("n", "<leader>wz", "<cmd>wincmd _ | wincmd |<CR>", { desc = "Zoom window" })
keymap("n", "<leader>wz", function()
	local is_zoomed = vim.w._zoomed

	if is_zoomed then
		vim.cmd("wincmd =")
		vim.w._zoomed = false
	else
		vim.cmd("wincmd _ | wincmd |")
		vim.w._zoomed = true
	end
end, { desc = "Toggle window zoom" })
keymap("n", "<leader>wo", ":only<CR>", { desc = "Keep only current window" })

--
-- Buffers
keymap("n", "<leader>bn", ":enew<CR>", { desc = "New buffer" })
keymap("n", "<leader>bw", ":w<CR>", { desc = "Save buffer" })
keymap("n", "<leader>bx", ":bd<CR>", { desc = "Close buffer" })
keymap("n", "<leader>bX", ":bd!<CR>", { desc = "Force close buffer" })
keymap("n", "<leader>bs", ":wa<CR>", { desc = "Save all buffers" })

--
-- Tabs
keymap("n", "<leader>tn", ":tabnew<CR>", { desc = "New tab" })
keymap("n", "<leader>tx", ":tabclose<CR>", { desc = "Close tab" })
keymap("n", "<leader>tX", ":tabonly<CR>", { desc = "Close other tabs" })
keymap("n", "<leader>to", ":tab split<CR>", { desc = "Open buffer in new tab" })
