-- leader
vim.g.mapleader = " "


-- NeoTree 
vim.keymap.set('n','<leader>e', ':Neotree focus<CR>')
vim.keymap.set('n','<A-g>g',    ':Neotree focus git_status<CR>')
vim.keymap.set('n','<A-e>',     ':Neotree close<CR>')

-- quit
vim.keymap.set('n','<S-q>',     ':qa<CR>')


-- esc
vim.keymap.set( "i", "jk", "<esc>") 
vim.keymap.set( "i", "jj", "<esc>") 


-- SAVE  Leader + w
vim.keymap.set('n', '<leader>w', ':w<CR>', { silent = true }) 
vim.keymap.set('v', '<leader>w', ':w<CR>', { silent = true })
vim.keymap.set('i', '<leader>w', '<C-O>:w<CR>', { silent = true }) 
-- SAVE  Ctrl + S
vim.keymap.set('n', '<C-S>', ':update<CR>', { silent = true, noremap = true }) 
vim.keymap.set('v', '<C-S>', '<C-C>:update<CR>', { silent = true, noremap = true }) 
vim.keymap.set('i', '<C-S>', '<C-O>:update<CR>', { silent = true, noremap = true })
-- SAVE ctrl + return 
vim.keymap.set('n', '<C-CR>', ':update<CR>', { silent = true, noremap = true }) 
vim.keymap.set('v', '<C-CR>', '<C-C>:update<CR>', { silent = true, noremap = true }) 
vim.keymap.set('i', '<C-CR>', '<C-O>:update<CR>', { silent = true, noremap = true })


 
