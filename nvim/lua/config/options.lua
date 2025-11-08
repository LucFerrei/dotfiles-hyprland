-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Transparent background setup
vim.cmd([[
  augroup TransparentBG
    autocmd!
    autocmd ColorScheme * hi Normal ctermbg=none guibg=none
    autocmd ColorScheme * hi NormalNC ctermbg=none guibg=none
    autocmd ColorScheme * hi NormalFloat ctermbg=none guibg=none
    autocmd ColorScheme * hi SignColumn ctermbg=none guibg=none
    autocmd ColorScheme * hi LineNr ctermbg=none guibg=none
    autocmd ColorScheme * hi EndOfBuffer ctermbg=none guibg=none
  augroup END
]])
