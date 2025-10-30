-- Seamless system clipboard on macOS, Linux (X11/Wayland), and WSL.

-- Prefer sending *everything* to system clipboard:
vim.opt.clipboard = "unnamedplus"

local fn = vim.fn

-- Helper: trim Windows line endings when pasting from PowerShell
local function trim_crlf(lines)
	for i, s in ipairs(lines) do
		-- remove trailing \r
		lines[i] = s:gsub("\r$", "")
	end
	return lines
end

-- Detect environments
local is_wsl = (fn.has("wsl") == 1)
local is_mac = (fn.has("mac") == 1) or (vim.loop.os_uname().sysname == "Darwin")

-- Try Wayland first (wl-clipboard), then X11 (xclip), otherwise leave default
local function linux_clipboard()
	if fn.executable("wl-copy") == 1 and fn.executable("wl-paste") == 1 then
		return {
			name = "wl-clipboard (Wayland)",
			copy = {
				["+"] = "wl-copy --foreground --type text/plain",
				["*"] = "wl-copy --foreground --primary --type text/plain",
			},
			paste = { ["+"] = "wl-paste --no-newline", ["*"] = "wl-paste --primary --no-newline" },
			cache_enabled = 0,
		}
	elseif fn.executable("xclip") == 1 then
		return {
			name = "xclip (X11)",
			copy = { ["+"] = "xclip -selection clipboard", ["*"] = "xclip -selection primary" },
			paste = { ["+"] = "xclip -selection clipboard -o", ["*"] = "xclip -selection primary -o" },
			cache_enabled = 0,
		}
	elseif fn.executable("xsel") == 1 then
		return {
			name = "xsel (X11)",
			copy = { ["+"] = "xsel --clipboard --input", ["*"] = "xsel --primary --input" },
			paste = { ["+"] = "xsel --clipboard --output", ["*"] = "xsel --primary --output" },
			cache_enabled = 0,
		}
	end
	return nil
end

if is_wsl then
	-- WSL: copy via clip.exe, paste via PowerShell Get-Clipboard
	vim.g.clipboard = {
		name = "WSL-Clipboard",
		copy = {
			["+"] = "clip.exe",
			["*"] = "clip.exe",
		},
		paste = {
			["+"] = function()
				local out = fn.systemlist({ "powershell.exe", "-NoProfile", "-Command", "Get-Clipboard" })
				return trim_crlf(out)
			end,
			["*"] = function()
				local out = fn.systemlist({ "powershell.exe", "-NoProfile", "-Command", "Get-Clipboard" })
				return trim_crlf(out)
			end,
		},
		cache_enabled = 0,
	}
elseif is_mac then
	-- macOS: pbcopy/pbpaste are available; default provider usually suffices
	-- (You can omit this block; shown for completeness.)
	vim.g.clipboard = {
		name = "pbcopy",
		copy = { ["+"] = "pbcopy", ["*"] = "pbcopy" },
		paste = { ["+"] = "pbpaste", ["*"] = "pbpaste" },
		cache_enabled = 0,
	}
else
	-- Linux desktop: try Wayland, then X11
	local linux = linux_clipboard()
	if linux then
		vim.g.clipboard = linux
	end
end

-- OPTIONAL: Fallback for headless/tmux/SSH via OSC52 if no system tool works.
-- Requires plugin "ojroques/nvim-osc52" (add it to your plugin list).
-- This lets you copy over SSH/tmux to your *local* system clipboard.
local have_clip = (vim.g.clipboard ~= nil)
local in_tty = (vim.fn.has("gui_running") == 0) and (vim.env.SSH_TTY or vim.env.TMUX)

if (not have_clip) and in_tty then
	local ok, osc52 = pcall(require, "osc52")
	if ok then
		osc52.setup({ max_length = 0, silent = true, trim = true })
		-- Override yank to also send to OSC52
		local function osc_copy(lines, _)
			osc52.copy(table.concat(lines, "\n"))
		end
		vim.g.clipboard = {
			name = "OSC52",
			copy = { ["+"] = osc_copy, ["*"] = osc_copy },
			paste = {
				["+"] = function()
					return {}
				end,
				["*"] = function()
					return {}
				end,
			},
		}
	end
end

--

-- vim.keymap.set("x", "<leader>p", "\"_dP")
