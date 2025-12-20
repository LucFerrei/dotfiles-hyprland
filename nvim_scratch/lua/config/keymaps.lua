-- produtivity
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true, })
vim.keymap.set("n", ";", ":", { noremap = true, })

-- netrw
vim.keymap.set("n", "<leader>e", ":Lexplore<CR>", { noremap = true, silent = true, })
vim.keymap.set("n", "<leader>pv", ":ex .<CR>", { noremap = true, silent = true, })
