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
vim.keymap.set("t", "<C-t>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- open insert mode with blank line when in terminal and in normal mode
-- EDIT -> vim.keymap.set("t", "<C-n>", "a<C-o>", { desc = "Exit terminal mode and open new line" })

-- Terminal arrow emulation
-- In terminal mode, you can send bytes directly to the shell using Neovim’s nvim_chan_send() function, which writes to the terminal process’ input.
-- "\x1b[A" -> Up arrow
vim.keymap.set("t", "<C-h>", function()
	vim.api.nvim_chan_send(vim.b.terminal_job_id, "\x1b[D")
end, { desc = "Left arrow" })
vim.keymap.set("t", "<C-j>", function()
	vim.api.nvim_chan_send(vim.b.terminal_job_id, "\x1b[B")
end, { desc = "Down arrow" })
vim.keymap.set("t", "<C-k>", function()
	vim.api.nvim_chan_send(vim.b.terminal_job_id, "\x1b[A")
end, { desc = "Up arrow" })
vim.keymap.set("t", "<C-l>", function()
	vim.api.nvim_chan_send(vim.b.terminal_job_id, "\x1b[C")
end, { desc = "Right arrow" })

vim.keymap.set("t", "<C-n>wh", [[<C-\><C-n><C-w>h]], { desc = "Focus left window / Go to left window" })
vim.keymap.set("t", "<C-n>wj", [[<C-\><C-n><C-w>j]], { desc = "Focus lower window" })
vim.keymap.set("t", "<C-n>wk", [[<C-\><C-n><C-w>k]], { desc = "Focus upper window" })
vim.keymap.set("t", "<C-n>wl", [[<C-\><C-n><C-w>l]], { desc = "Focus right window" })

-- vim.keymap.set("t", "<C-e>", function()
-- 	vim.api.nvim_chan_send(vim.b.terminal_job_id, "!!\n")
-- end, { desc = "Repeat last shell command" })

-- vim.keymap.set("t", "<C-l>", function()
-- 	-- clear terminal scrollback
-- 	vim.api.nvim_input("<C-\\><C-n>")
-- 	vim.cmd("startinsert")
-- 	vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
-- end, { desc = "Clear terminal buffer" })

-- persistent console

-- TODO ???
-- keymap("t", "<leader>wy", function()
--   -- Exit terminal mode temporarily
--   vim.api.nvim_input("<C-\\><C-n>")
--
--   -- Get all buffer lines
--   local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
--   local output = {}
--
--   -- Find the last two prompts
--   local last_prompt, second_last_prompt
--   for i = #lines, 1, -1 do
--     if lines[i]:match("^[%w@%-_~%.]+%$ ") then -- basic prompt pattern like 'user@host$ '
--       if not last_prompt then
--         last_prompt = i
--       elseif not second_last_prompt then
--         second_last_prompt = i
--         break
--       end
--     end
--   end
--
--   if not second_last_prompt then
--     vim.notify("Could not detect previous command output", vim.log.levels.WARN)
--     return
--   end
--
--   -- Extract output between the two prompts
--   for i = second_last_prompt + 1, last_prompt - 1 do
--     table.insert(output, lines[i])
--   end
--
--   -- Copy to system clipboard
--   local text = table.concat(output, "\n")
--   vim.fn.setreg("+", text)
--   vim.notify("Copied last command output (" .. #output .. " lines)")
-- end, { desc = "Copy last command output from terminal" })
