local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local ok, msg = pcall(vim.fn.system, {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
	if not ok then
		print("Error downloading lazy: ", msg)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ "nvim-treesitter/nvim-treesitter", branch = "master", lazy = false, build = ":TSUpdate" },
	{ "neovim/nvim-lspconfig" },

	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				-- ensure_installed = { "" },
			})
		end,
	},

	{
		"stevearc/conform.nvim",
		config = function()
			local conform = require("conform")

			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "black" },
				},
				format_on_save = {
					lsp_fallback = true,
					timeout_ms = 500,
				},
			})

			vim.api.nvim_create_autocmd("BufWritePre", {
				callback = function(args)
					local ft = vim.bo[args.buf].filetype
					if conform.formatters_by_ft[ft] then
						conform.format({ bufnr = args.buf })
					end
				end,
			})
		end,
	},

	{ "mfussenegger/nvim-lint" },
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"stevearc/oil.nvim",
		opts = {
			default_file_explorer = true, -- replaces netrw
			view_options = {
				show_hidden = true,
			},
		},
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				actions = {
					open_file = {
						quit_on_open = true, -- closes tree when you open a file
					},
				},
			})
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		config = function()
			require("which-key").setup()
		end,
	},
	{ "numToStr/Comment.nvim", opts = {} },

	--

	-- Core completion engine
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter", -- load cmp when you start typing
		dependencies = {
			"hrsh7th/cmp-buffer", -- source: words from current buffer
			"hrsh7th/cmp-path", -- source: file paths
			"hrsh7th/cmp-nvim-lsp", -- source: LSP servers
			"hrsh7th/cmp-nvim-lua", -- optional: Lua API completions
			"L3MON4D3/LuaSnip", -- snippet engine
			"saadparwaiz1/cmp_luasnip", -- connect snippets to cmp
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({

				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},

				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},

				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-e>"] = cmp.mapping.abort(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "copilot" },
				}, {
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},

	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		-- build = ":Copilot auth",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = true },
				panel = { enabled = true },
			})
		end,
	},
	-- Bridge between Copilot and nvim-cmp
	{
		"zbirenbaum/copilot-cmp",
		dependencies = { "zbirenbaum/copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		build = "make tiktoken",
		config = function()
			require("CopilotChat").setup({
				model = "gpt-4.1",
				temperature = 0.2,
				window = {
					layout = "vertical",
					width = 0.5,
					title = "🤖 Copilot Chat",
				},
			})
		end,
	},
	-- Style plugins
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		priority = 1000,
		config = function()
			require("rose-pine").setup({
				variant = "moon", -- auto, main, moon, or dawn
				dark_variant = "moon", -- ensures dark mode
				disable_background = false, -- true = transparent
				bold_vert_split = false,
				dim_nc_background = true,
				extend_background_behind_borders = true,
				styles = {
					italic = true, -- enables italics globally
				},
				highlight_groups = {
					Comment = { italic = true }, -- ensure comments are italic
				},
			})

			vim.cmd("colorscheme rose-pine")
		end,
	},
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
		opts = {
			color_icons = true, -- enable per-icon color
			default = true, -- show a default icon for unknown files
			override_by_filename = {
				[".gitignore"] = {
					icon = "",
					color = "#f1502f",
					name = "Gitignore",
				},
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = "auto", -- match your colorscheme (tokyonight, rose-pine, catppuccin, gruvbox, dracula, etc)
				section_separators = "",
				component_separators = "",
			},
		},
	},
})

vim.lsp.config.stylua = {}

require("lint").linters_by_ft = {
	-- lua = { "luacheck" }
}
vim.api.nvim_create_autocmd({ "BufWritePost", "insertLeave" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

-- ????
local capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config.pyright = { capabilities = capabilities }
