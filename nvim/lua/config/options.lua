-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Transparent background setup
-- vim.cmd([[
--   augroup TransparentBG
--     autocmd!
--     autocmd ColorScheme * hi Normal ctermbg=none guibg=none
--     autocmd ColorScheme * hi NormalNC ctermbg=none guibg=none
--     autocmd ColorScheme * hi NormalFloat ctermbg=none guibg=none
--     autocmd ColorScheme * hi SignColumn ctermbg=none guibg=none
--     autocmd ColorScheme * hi LineNr ctermbg=none guibg=none
--     autocmd ColorScheme * hi EndOfBuffer ctermbg=none guibg=none
--   augroup END
-- ]])
vim.cmd([[
  augroup TransparentBG
    autocmd!
    autocmd ColorScheme * hi Normal ctermbg=none guibg=none
    autocmd ColorScheme * hi NormalNC ctermbg=none guibg=none
    autocmd ColorScheme * hi NormalFloat ctermbg=none guibg=none
    autocmd ColorScheme * hi FloatBorder ctermbg=none guibg=none
    autocmd ColorScheme * hi NonText ctermbg=none guibg=none
    autocmd ColorScheme * hi SignColumn ctermbg=none guibg=none
    autocmd ColorScheme * hi LineNr ctermbg=none guibg=none
    autocmd ColorScheme * hi EndOfBuffer ctermbg=none guibg=none
    autocmd ColorScheme * hi Pmenu ctermbg=none guibg=none
    autocmd ColorScheme * hi PmenuSel ctermbg=none guibg=none
    
    -- NOVO: Limpa o fundo do título (usado em :help ou na tela de boas-vindas)
    autocmd ColorScheme * hi Title ctermbg=none guibg=none 
    
    -- NOVO: Limpa o fundo para o separador de splits (se estiver opaco)
    autocmd ColorScheme * hi VertSplit ctermbg=none guibg=none 
    
    -- E, se o seu tema estiver colorindo a barra de comandos, limpe-a
    autocmd ColorScheme * hi CmdLine ctermbg=none guibg=none 

    -- Plugins (Neo-tree e StatusLine, se estiverem opacos):
    autocmd ColorScheme * hi NeoTreeNormal ctermbg=none guibg=none
    -- autocmd ColorScheme * hi StatusLine ctermbg=none guibg=none
  augroup END
]])
