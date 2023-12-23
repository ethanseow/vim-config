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
vim.cmd([[Plug 'neoclide/coc.nvim', {'branch': 'release'}]])
vim.cmd([[Plug 'christoomey/vim-tmux-navigator']])
vim.cmd([[Plug 'romgrk/barbar.nvim']])
vim.cmd([[Plug 'lewis6991/gitsigns.nvim']])
vim.cmd([[Plug 'nvim-tree/nvim-tree.lua']])
vim.cmd([[Plug 'nvim-tree/nvim-web-devicons']])
vim.cmd([[Plug 'mhartington/formatter.nvim']])
vim.cmd([[Plug 'https://github.com/vim-airline/vim-airline']])
vim.cmd([[Plug 'vim-airline/vim-airline-themes']])
vim.cmd([[Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' } ]])
vim.cmd([[Plug 'nvim-lua/plenary.nvim']])
vim.cmd([[Plug 'windwp/nvim-autopairs']])
vim.cmd([[Plug 'nvim-treesitter/nvim-treesitter']])
vim.cmd([[Plug 'sainnhe/sonokai']])
vim.cmd([[call plug#end()]])

-- Colorscheme and Airline theme
vim.g.airline_theme = "sonokai"
vim.cmd([[
let g:sonokai_style = 'andromeda'
let g:sonokai_better_performance = 1

colorscheme sonokai
]])

-- ctrl+s
vim.keymap.set("n", "<C-s>", ":update<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-s>", "<Esc> :update<CR>", { noremap = true, silent = true })
-- quit and save all
vim.keymap.set("n", "<C-q>", ":wqa! <CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-q>", "<Esc> :wqa!<CR>", { noremap = true, silent = true })

-- nvim-autopairs
require("nvim-autopairs").setup({})

-- barbar
require("barbar").setup()

-- nvim-tree
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
	nvimTreeApi.tree.toggle()
end
vim.keymap.set("n", "<C-b>", toggleTree, { noremap = true, silent = true })
vim.keymap.set("i", "<C-b>", toggleTree, { noremap = true, silent = true })
toggleTree()

-- telescope
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

-- Formatter - format on save
vim.cmd(
	[[
augroup FormatAutogroup
autocmd!
  autocmd BufWritePost * FormatWrite
augroup END
]],
	false
)

-- Visual mode key mappings
vim.keymap.set("x", "<Tab>", ">", { noremap = true, silent = true })
vim.keymap.set("x", "<S-Tab>", "<", { noremap = true, silent = true })

-- Normal mode and insert mode key mappings
vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true, silent = true })
vim.keymap.set("i", "<C-a>", "<Esc>ggVG", { noremap = true, silent = true })

-- COC
function _G.check_back_space()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

-- Use Tab for trigger completion with characters ahead and navigate
-- NOTE: There's always a completion item selected by default, you may want to enable
-- no select by setting `"suggest.noselect": true` in your configuration file
-- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
-- other plugins before putting this into your config
local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
vim.keymap.set(
	"i",
	"<TAB>",
	'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<C-f>" : coc#refresh()',
	opts
)
vim.keymap.set("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice
vim.keymap.set("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

vim.cmd([[nmap <silent> gd <Plug>(coc-definition)]])
vim.cmd([[nmap <silent> gy <Plug>(coc-type-definition)]])
vim.cmd([[nmap <silent> gi <Plug>(coc-implementation)]])
vim.cmd([[nmap <silent> gr <Plug>(coc-references)]])

vim.cmd([[nmap rr <Plug>(coc-rename)]])

-- Use K to show documentation in preview window
function _G.show_docs()
	local cw = vim.fn.expand("<cword>")
	if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
		vim.api.nvim_command("h " .. cw)
	elseif vim.api.nvim_eval("coc#rpc#ready()") then
		vim.fn.CocActionAsync("doHover")
	else
		vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
	end
end
vim.keymap.set("n", "gh", "<CMD>lua _G.show_docs()<CR>", { silent = true })

vim.o.re = 0

-- Treesitter
require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all" (the five listed parsers should always be installed)
	ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "html" },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = false,

	-- List of parsers to ignore installing (or "all")
	ignore_install = {},

	highlight = {
		enable = true,
		disable = { "" },
		additional_vim_regex_highlighting = false,
		autotag = { enable = true },
	},
})
