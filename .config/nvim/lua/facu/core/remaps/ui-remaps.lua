-- UI
vim.keymap.set("n", "<leader>un", function()
	vim.opt.relativenumber = not vim.wo.relativenumber
end, { desc = "Toggle relative line numbers" })

vim.keymap.set("n", "<leader>ub", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- --
-- --
-- -- Only works with GUI clients like Neovide, Goneovim, etc.
-- --
-- -- Default font (adjust name to your actual font)
-- local default_font = "JetBrainsMono Nerd Font:h14"
--
-- -- Helper to change font size dynamically
-- local function adjust_font(delta)
-- 	local guifont = vim.opt.guifont:get()
-- 	if not guifont or not guifont[1] or guifont[1] == "" then
-- 		vim.notify("Font zoom only works in Neovim GUIs (e.g. Neovide, Goneovim).", vim.log.levels.WARN)
-- 		return
-- 	end
--
-- 	local name, size = guifont[1]:match("^(.*):h(%d+)")
-- 	if not name or not size then
-- 		vim.notify("Unable to parse current guifont: " .. guifont[1], vim.log.levels.ERROR)
-- 		return
-- 	end
--
-- 	size = tonumber(size) + delta
-- 	if size < 6 then
-- 		size = 6
-- 	end -- prevent absurdly small fonts
--
-- 	vim.opt.guifont = string.format("%s:h%d", name, size)
-- 	vim.notify(string.format("Font size: %d", size))
-- end
--
-- -- Increase / Decrease / Reset font size
-- vim.keymap.set("n", "<leader>u+", function()
-- 	adjust_font(1)
-- end, { desc = "Increase font size" })
-- vim.keymap.set("n", "<leader>u-", function()
-- 	adjust_font(-1)
-- end, { desc = "Decrease font size" })
-- vim.keymap.set("n", "<leader>u0", function()
-- 	vim.opt.guifont = default_font
-- end, { desc = "Reset font size" })
