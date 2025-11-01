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

return M
