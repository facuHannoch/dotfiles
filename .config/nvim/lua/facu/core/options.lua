local opt = vim.opt

vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect", "popup" }

opt.number = true
opt.relativenumber = true

opt.mouse = "a" -- allow mouse on all modes

-- 2️⃣ Indentation
opt.tabstop = 4 -- Number of spaces that a <Tab> in the file counts for
opt.shiftwidth = 4 -- Number of spaces used for autoindent
opt.expandtab = true -- Use spaces instead of tabs
opt.smartindent = true -- Automatically insert indentation in some cases
opt.autoindent = true -- Copy indent from current line when starting a new one

-- 3️⃣ Other good defaults
opt.wrap = false -- No line wrapping
opt.scrolloff = 8 -- Keep 8 lines visible above/below cursor when scrolling
opt.sidescrolloff = 8 -- Same for horizontal scroll
opt.cursorline = true -- Highlight current line
opt.termguicolors = true -- Enable 24-bit colors
opt.signcolumn = "yes" -- Always show sign column (for LSP, git, etc.)

-- 4️⃣ File encoding and undo
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.undofile = true -- Persistent undo

-- 5️⃣ Searching
opt.ignorecase = true -- Ignore case when searching...
opt.smartcase = true -- ...unless search has uppercase
opt.incsearch = true -- Show matches while typing
opt.hlsearch = false -- Don’t highlight all matches by default

-- 6️⃣ Split behavior
opt.splitbelow = true
opt.splitright = true

-- AutoSave

-- Style specific plugins

opt.termguicolors = true
-- vim.cmd("syntax enable")
-- vim.cmd("filetype plugin indent on")
