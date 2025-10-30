local autosave_enabled = true

local function toggle_autosave()
	autosave_enabled = not autosave_enabled
	print("Autosave " .. (autosave_enabled and "enabled" or "disabled"))
end

vim.api.nvim_create_user_command("ToggleAutosave", toggle_autosave, {})

-- -- Auto-save whenever you leave insert mode or Neovim loses focus
-- vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost" }, {
--   pattern = "*",
--   command = "silent! wall",  -- "wall" = write all modified buffers
-- })

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
	callback = function()
		if autosave_enabled and vim.bo.modified and vim.bo.buftype == "" then
			vim.cmd("silent write")
		end
	end,
})

-- -- Idle autosave (after N seconds)
-- vim.opt.updatetime = 2000  -- 2 seconds
-- vim.api.nvim_create_autocmd("CursorHold", {
--   callback = function()
--     if autosave_enabled and vim.bo.modified and vim.bo.buftype == "" then
--       vim.cmd("silent write")
--     end
--   end,
-- })
