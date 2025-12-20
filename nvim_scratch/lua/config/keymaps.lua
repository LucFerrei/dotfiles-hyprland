-- produtivity
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true, })
vim.keymap.set("n", ";", ":", { noremap = true, })

-- Neo-Tree & Oil
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true, })
vim.keymap.set("n", "<leader>pv", ":Oil<CR>", { noremap = true, silent = true, })

-- window
vim.keymap.set("n", "<leader>h", "<C-w>h", { noremap = true, silent = true, })
vim.keymap.set("n", "<leader>j", "<C-w>j", { noremap = true, silent = true, })
vim.keymap.set("n", "<leader>k", "<C-w>k", { noremap = true, silent = true, })
vim.keymap.set("n", "<leader>l", "<C-w>l", { noremap = true, silent = true, })
