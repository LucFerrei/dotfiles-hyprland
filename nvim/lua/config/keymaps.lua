-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>l", "<cmd>bn<CR>", { noremap = true, silent = true, desc = "go to next buffer" })
vim.keymap.set("n", "<leader>h", "<cmd>bp<CR>", { noremap = true, silent = true, desc = "go to previous buffer" })

vim.keymap.set("n", "o", "o<Esc>", { noremap = true, silent = true, desc = "create new line beyond" })
vim.keymap.set("n", "O", "O<Esc>", { noremap = true, silent = true, desc = "create new line beyond" })

vim.keymap.set("n", ";", ":", { noremap = true, silent = true, desc = "Comando" })

vim.keymap.set("n", ":", ";", { noremap = true, silent = true, desc = "Repetir busca de caractere" })

vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true, desc = "Sair do Modo Inserção" })

vim.keymap.set("i", "kj", "<Esc>", { noremap = true, silent = true, desc = "Sair do Modo Inserção" })

vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { silent = true, desc = "Toggle Neo-tree" })
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { silent = true, desc = "Toggle Neo-tree" })
