-- Code
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format file" })
vim.keymap.set("n", "<leader>cc", function()
	require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment" })
vim.keymap.set("n", "<leader>cw", function()
	vim.opt.wrap = not vim.wo.wrap
end, { desc = "Toggle line wrap" })

keymap.set(
	"v",
	"<leader>cc",
	"<ESC><CMD>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
	{ desc = "Toggle comment (visual)" }
)
