-- Utilities for creating configurations
local util = require("formatter.util")
function prettier()
	local p = require("formatter.filetypes.javascript").prettier()
	table.insert(p.args, "--tab-width")
	table.insert(p.args, "4")
	return p
end
require("formatter").setup({
	logging = true,
	log_level = vim.log.levels.WARN,
	filetype = {
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
		python = {
			require("formatter.filetypes.python").black,
		},
		c = {
			require("formatter.filetypes.c").clangformat,
		},
		javascript = {
			prettier,
		},
		javascriptreact = {
			prettier,
		},
		["*"] = {
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})
