-- Функция для переключения режима (день/ночь)
if vim.o.background == "light" then
	vim.g.everforest_background = "hard"
	vim.cmd([[
  highlight Cursor guifg=#BABABA guibg=#4C4F6A
  highlight CursorInsert guifg=#BABABA guibg=#4C4F6A
]])
else
	vim.g.everforest_background = "medium"
	vim.cmd([[
  highlight Cursor guifg=#1E1E2E guibg=#BABABA
  highlight CursorInsert guifg=#1E1E2E guibg=#BABABA
]])
end
vim.cmd("colorscheme everforest")
