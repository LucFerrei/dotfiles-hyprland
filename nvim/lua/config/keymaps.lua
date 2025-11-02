-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>l", "<cmd>bn<CR>", { noremap = true, silent = true, desc = "go to next buffer" })
vim.keymap.set("n", "<leader>h", "<cmd>bp<CR>", { noremap = true, silent = true, desc = "go to previous buffer" })

-- Remapeia o ; para entrar no Modo de Comando (:)
vim.keymap.set("n", ";", ":", { noremap = true, silent = true, desc = "Comando" })

-- Opcional, mas recomendado: Mapear o : de volta para a função original do ;
-- (Repetir o último f, t, F ou T)
vim.keymap.set("n", ":", ";", { noremap = true, silent = true, desc = "Repetir busca de caractere" })

-- Mapeia 'jk' para <Esc> no Modo de Inserção
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true, desc = "Sair do Modo Inserção" })


-- Opcional: Mapear 'kj' também
vim.keymap.set('i', 'kj', '<Esc>', { noremap = true, silent = true, desc = 'Sair do Modo Inserção' })
