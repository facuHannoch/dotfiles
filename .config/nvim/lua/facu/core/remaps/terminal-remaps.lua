vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	command = "startinsert",
})
--
vim.keymap.set("n", "<leader>wtv", ":vsplit | terminal<CR>", { desc = "Open terminal in vertical split" })
vim.keymap.set("n", "<leader>wth", ":split | terminal<CR>", { desc = "Open terminal in horizontal split" })
vim.keymap.set("n", "<leader>wt", ":tabnew | terminal<CR>", { desc = "Open terminal in new tab" })

-- Inside terminal mode
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Go to left window" })
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { desc = "Go to lower window" })
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "Go to upper window" })
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "Go to right window" })

-- In terminal mode, you can send bytes directly to the shell using Neovim’s nvim_chan_send() function, which writes to the terminal process’ input.
vim.keymap.set("t", "<C-p>", function()
	vim.api.nvim_chan_send(vim.b.terminal_job_id, "\x1b[A") -- Up arrow
end, { desc = "Previous command in terminal history" })

vim.keymap.set("t", "<C-n>", function()
	vim.api.nvim_chan_send(vim.b.terminal_job_id, "\x1b[B") -- Down arrow
end, { desc = "Next command in terminal history" })

vim.keymap.set("t", "<C-o>", function()
	vim.api.nvim_chan_send(vim.b.terminal_job_id, "\x1b[C")
end, { desc = "Accept shell autocomplete suggestion" })

vim.keymap.set("t", "<C-e>", function()
	vim.api.nvim_chan_send(vim.b.terminal_job_id, "!!\n")
end, { desc = "Repeat last shell command" })

vim.keymap.set("t", "<C-l>", function()
	-- clear terminal scrollback
	vim.api.nvim_input("<C-\\><C-n>")
	vim.cmd("startinsert")
	vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
end, { desc = "Clear terminal buffer" })

-- persistent console
