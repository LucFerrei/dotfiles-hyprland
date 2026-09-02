-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.termguicolors = true

vim.opt.wrap = true -- quebra a linha visualmente
vim.opt.linebreak = true -- quebra em espaços, não no meio da palavra
vim.opt.breakindent = true -- mantém a indentação nas linhas quebradas

vim.opt.colorcolumn = "120"
vim.opt.textwidth = 120 -- quebra automaticamente aos 80 caracteres
vim.opt.formatoptions:append("t") -- ativa auto-quebra ao digitar
