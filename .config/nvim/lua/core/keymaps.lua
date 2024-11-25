-- leader key 
vim.g.mapleader = " "

-- normal mode saves 
vim.keymap.set("n",  "<leader>w",  ":w<CR>",       { noremap = true, silent = true})
vim.keymap.set("n",  "<C-s>",      ":w<CR>",       { noremap = true, silent = true})
vim.keymap.set("n",  "<C-Return>", ":w<CR>", 	   { noremap = true, silent = true})

-- insert mode saves 
vim.keymap.set("i",  "<C-s>",      "<Esc>:w<CR>a", { noremap = true, silent = true})
vim.keymap.set("i",  "<C-Return>", "<Esc>:w<CR>a", { noremap = true, silent = true})

-- esc 
vim.keymap.set("i",  "jk",         "<Esc>",        { noremap = true, silent = true})

-- neotree normal
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-e>", "<Esc>:Neotree toggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>f", ":Neotree focus<CR>" , { noremap = true, silent = true })
vim.keymap.set("n", "<A-S-e>", "<Esc>:Neotree focus filesystem<CR>" , { noremap = true, silent = true })
vim.keymap.set("n", "<A-S-f>", "<Esc>:Neotree focus<CR>" , { noremap = true, silent = true })

vim.keymap.set("i", "<A-e>", "<Esc>:Neotree toggle<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<A-S-e>", "<Esc>:Neotree focus filesystem<CR>" , { noremap = true, silent = true })
vim.keymap.set("i", "<A-S-f>", "<Esc>:Neotree focus<CR>" , { noremap = true, silent = true })

