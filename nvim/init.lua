-- bootstrap lazy.nvim, LazyVim and your plugins

require("config.lazy")

local function rose_pine_theme(variant, is_transparent)
  require("rose-pine").setup({
    variant = variant,
    styles = {
      transparency = is_transparent
    },
  })
  vim.cmd("colorscheme rose-pine")
end

vim.api.nvim_create_user_command(
  "NvimDia",
  function()
    rose_pine_theme("dawn", false)
    print("Modo dia ativado")
  end,
  { desc = "Ativa o modo dia" }
)

vim.api.nvim_create_user_command(
  "NvimNoite",
  function()
    rose_pine_theme("moon", true)
    print("Modo noite ativado")
  end,
  { desc = "Ativa o modo noite" }
)
