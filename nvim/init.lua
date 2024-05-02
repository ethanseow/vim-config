vim.o.number = true
vim.o.relativenumber = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.copyindent = true

vim.o.mouse = "a"

-- vim-plug
vim.cmd([[call plug#begin()]])
vim.cmd([[Plug 'romgrk/barbar.nvim']])
vim.cmd([[Plug 'lewis6991/gitsigns.nvim']])
vim.cmd([[Plug 'nvim-tree/nvim-tree.lua']])
vim.cmd([[Plug 'mhartington/formatter.nvim']])
vim.cmd([[Plug 'https://github.com/vim-airline/vim-airline']])
vim.cmd([[Plug 'nvim-tree/nvim-web-devicons']])
vim.cmd([[Plug 'vim-airline/vim-airline-themes']])
vim.cmd([[Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' } ]])
vim.cmd([[Plug 'nvim-lua/plenary.nvim']])
vim.cmd([[Plug 'sainnhe/sonokai']])
vim.cmd([[Plug 'neoclide/coc.nvim', {'branch': 'release'}]])
vim.cmd([[Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}]])
vim.cmd([[call plug#end()]])

--
-- vim.cmd([[Plug 'vim-airline/vim-airline-themes']])
-- vim.cmd([[Plug 'https://github.com/vim-airline/vim-airline']])
--
vim.g.airline_theme = "sonokai"
vim.cmd([[
let g:sonokai_style = 'andromeda'
let g:sonokai_better_performance = 1
colorscheme sonokai
set clipboard+=unnamedplus
]])

-- ctrl+s
vim.keymap.set("n", "<C-s>", ":update <CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-s>", "<Esc> :update <CR>", { noremap = true, silent = true })
-- quit and save all
vim.keymap.set("n", "<C-q>", ":wqa! <CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-q>", "<Esc> :wqa!<CR>", { noremap = true, silent = true })

--
-- vim.cmd([[Plug 'romgrk/barbar.nvim']])
--
require("barbar").setup()

--
-- vim.cmd([[Plug 'nvim-tree/nvim-tree.lua']])
--
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require("nvim-tree").setup()
require("nvim-web-devicons").setup()
function toggleTree()
	local nvimTreeApi = require("nvim-tree.api")
	local barbarApi = require("barbar.api")
	if nvimTreeApi.tree.is_visible() then
		barbarApi.set_offset(0)
	else
		barbarApi.set_offset(31, "File Explorer", "BufferOffset", "left")
	end
	nvimTreeApi.tree.toggle({ find_file = true, focus = true })
end
function goBackToEditor()
	vim.cmd("wincmd l")
end
vim.keymap.set("n", "<C-b>", toggleTree, { noremap = true, silent = true })
vim.keymap.set("i", "<C-b>", toggleTree, { noremap = true, silent = true })
toggleTree()
goBackToEditor()

--
-- vim.cmd([[Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' } ]])
--
local builtin = require("telescope.builtin")
function findFiles()
	local function callGitFiles()
		return builtin.git_files({})
	end
	local status, error = pcall(callGitFiles)
	if not status then
		builtin.find_files({})
	end
end
vim.keymap.set("n", "<C-p>", findFiles, { noremap = true })

--
-- vim.cmd([[Plug 'mhartington/formatter.nvim']])
--
-- Formatter - format on save
vim.cmd(
	[[
augroup FormatAutogroup
autocmd!
  autocmd BufWritePost * Format
augroup END
]],
	false
)

--
-- vim.cmd([[Plug 'neoclide/coc.nvim', {'branch': 'release'}]])
--
-- list of extensions for coc.nvim
vim.cmd([[
let g:coc_global_extensions = ['coc-clangd', 'coc-pairs', 'coc-pyright','coc-tsserver', '@yaegassy/coc-tailwindcss3', 'coc-snippets']
]])

--
-- vim.cmd([[Plug 'nvim-treesitter/nvim-treesitter']])
--
require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all" (the five listed parsers should always be installed)
	ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "html", "python" },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,

	-- List of parsers to ignore installing (or "all")
	ignore_install = {},

	highlight = {
		enable = true,
		disable = { "" },
		additional_vim_regex_highlighting = false,
		autotag = { enable = true },
	},
})

vim.keymap.set(
	"i",
	"<TAB>",
	'<cmd>lua require("coc")._select_confirm()<CR>',
	{ expr = true, noremap = true, silent = true }
)
vim.keymap.set(
	"i",
	"<TAB>",
	'<cmd>lua require("coc").rpc.request("doKeymap", {"snippets-expand-jump", ""})<CR>',
	{ expr = true, noremap = true, silent = true }
)
vim.keymap.set(
	"i",
	"<TAB>",
	'<cmd>lua CheckBackspace() and "<TAB>" or nil<CR>',
	{ expr = true, noremap = true, silent = true }
)
vim.keymap.set("i", "<TAB>", '<cmd>lua require("coc").refresh()<CR>', { expr = true, noremap = true, silent = true })

function CheckBackspace()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

vim.g.coc_snippet_next = "<tab>"
