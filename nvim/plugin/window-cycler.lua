function WaitForCount(key)
	vim.api.nvim_input(":" .. key .. "wincmd w")
	vim.api.nvim_input("\n")
end

for key = 0, 9 do
	local mapping = string.format([[:lua WaitForCount('%s')<CR>]], key)
	local escMapping = string.format([[:lua <Esc> WaitForCount('%s')<CR>]], key)
	vim.api.nvim_set_keymap("n", string.format("<C-w>%d", key), mapping, { noremap = true, silent = true })
	vim.api.nvim_set_keymap("t", string.format("<C-w>%d", key), escMapping, { noremap = true, silent = true })
end
