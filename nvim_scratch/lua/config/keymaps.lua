-- Produtivity
vim.keymap.set("n", ";", ":", { noremap = true, })
--- moves
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true, })
vim.keymap.set("i", "kj", "<Esc>", { noremap = true, silent = true, })
--- move lines (insert mode)
vim.keymap.set("n", "m", "<Cmd>m+1<CR>", { noremap = true, silent = true, })
vim.keymap.set("n", "m", "<Cmd>m+1<CR>", { noremap = true, silent = true, })
--- move lines (visual mode)
vim.keymap.set("v", "m", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, })
vim.keymap.set("v", "M", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, })

-- Telescope
vim.keymap.set("n", "<leader>ff", "<Cmd>Telescope find_files<CR>", { noremap = true, silent = true, })
vim.keymap.set("n", "<leader>fg", "<Cmd>Telescope git_files<CR>", { noremap = true, silent = true, })
vim.keymap.set("n", "<leader>fb", "<Cmd>Telescope buffers<CR>", { noremap = true, silent = true, })
vim.keymap.set("n", "<leader>fl", "<Cmd>Telescope live_grep<CR>", { noremap = true, silent = true, })

-- LSP
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.rename, { noremap = true, silent = true, })
vim.keymap.set("n", "<leader>F", vim.lsp.buf.format, { noremap = true, silent = true, })

-- Neo-Tree & Oil
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true, })
vim.keymap.set("n", "<leader>pv", ":Oil<CR>", { noremap = true, silent = true, })

-- Buffers
vim.keymap.set("n", "<leader>bl", "<Cmd>bn<CR>", { noremap = true, silent = true, })
vim.keymap.set("n", "<leader>bh", "<Cmd>bp<CR>", { noremap = true, silent = true, })
vim.keymap.set("n", "<leader>bd", "<Cmd>confirm bd<CR>", { noremap = true, silent = true, })

-- Window
vim.keymap.set("n", "<leader>wh", "<C-w>h", { noremap = true, silent = true, })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { noremap = true, silent = true, })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { noremap = true, silent = true, })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { noremap = true, silent = true, })

-- identation
vim.keymap.set("n", ">", ">>", { noremap = true, silent = true })
vim.keymap.set("n", "<", "<<", { noremap = true, silent = true })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true })
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true })

-- Render Markdown.nvim
vim.keymap.set("n", "<leader><BS>", "<Cmd>RenderMarkdown buf_toggle<CR>", { noremap = true, silent = true })
