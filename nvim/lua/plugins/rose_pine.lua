-- ~/.config/nvim/lua/plugins/rose_pine.lua
return {
  {
    "rose-pine/neovim",
    name = "rose-pine", -- Nome usado para o colorscheme
    priority = 1000, -- Garante que seja carregado cedo
    opts = {
      -- Opções de Rosé Pine:
      variant = "auto", -- Deixa o Rosé Pine escolher (dawn para claro, dark_variant para escuro)
      dark_variant = "main", -- Define a variante escura como 'main'

      -- O Rosé Pine usa 'dawn' automaticamente para o modo claro quando 'variant' é 'auto'

      -- Exemplo de outras configurações (opcional):
      styles = {
        bold = true,
        italic = true,
        transparency = false,
      },
    },
    -- Carregue o colorscheme Rosé Pine no final da configuração
    config = function()
      vim.cmd("colorscheme rose-pine")
    end,
  },
}
