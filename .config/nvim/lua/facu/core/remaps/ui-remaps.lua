-- UI
vim.keymap.set("n", "<leader>un", function()
	vim.opt.relativenumber = not vim.wo.relativenumber
end, { desc = "Toggle relative line numbers" })
