-- Toggle between multiple tabs in vim
for i = 1, 9 do
	-- Switch to tab using Ctrl + <number>
	vim.api.nvim_set_keymap(
		"n",
		string.format("<C-%d>", i),
		string.format(":%dtabn<CR>", i),
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"i",
		string.format("<C-%d>", i),
		string.format(":%dtabn<CR>", i),
		{ noremap = true, silent = true }
	)
end

-- Open a new tab in Vim
vim.api.nvim_set_keymap("n", "<C-t>", ":tabnew<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-t>", "<Esc> :tabnew<CR>", { noremap = true, silent = true })

-- Close the current tab in Vim
vim.api.nvim_set_keymap("n", "<C-w>", ":tabclose<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-w>", "<Esc> :tabclose<CR>", { noremap = true, silent = true })
