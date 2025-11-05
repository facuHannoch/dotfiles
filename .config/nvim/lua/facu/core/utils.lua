local M = {}

function M.toggle_zoom()
	local is_zoomed = vim.w._zoomed

	if is_zoomed then
		vim.cmd("wincmd =")
		vim.w._zoomed = false
	else
		vim.cmd("wincmd _ | wincmd |")
		vim.w._zoomed = true
	end
end

local has_telescope, telescope = pcall(require, "telescope.builtin")

function M.file_diff(mode)
	mode = mode or "vert" -- default mode is vertical
	if mode ~= "" then
		mode = mode .. " "
	end

	local file = vim.fn.input('Compare with ("": telescope; path; #: alternative buffer): ')

	if file == "" then
		if has_telescope then
			telescope.find_files({
				prompt_title = "Select file to diff with",
				attach_mappings = function(_, map)
					local actions = require("telescope.actions")
					local action_state = require("telescope.actions.state")
					map("i", "<CR>", function(bufnr)
						local selection = action_state.get_selected_entry()
						actions.close(bufnr)
						local file = selection.path or selection.value
						vim.cmd(mode .. "diffsplit " .. vim.fn.fnameescape(file))
					end)
					return true
				end,
			})
		else
			vim.notify("Telescope not available — please enter a file path.", vim.log.levels.WARN)
		end
		return
	end

	-- if file == "" then
	--     vim.notify("No file selected", vim.log.levels.WARN
	--     return
	-- end
	if file == "#" then
		vim.cmd(mode .. "diffsplit #")
		return
	end
	-- 3️⃣ Compare with given file path
	vim.cmd(mode .. "diffsplit " .. vim.fn.fnameescape(file))
end

return M
