return {
  {
    "f-person/auto-dark-mode.nvim",
    config = function()
      require("auto-dark-mode").setup({
        update_interval = 1000, -- Verifica a cada 1 segundo

        -- Quando o sistema estiver CLARO:
        set_light_mode = function()
          -- Define 'background' para 'light'. O Rose Pine verá isso e aplicará 'dawn'.
          vim.api.nvim_set_option("background", "light")
        end,

        -- Quando o sistema estiver ESCURO:
        set_dark_mode = function()
          -- Define 'background' para 'dark'. O Rose Pine verá isso e aplicará 'main'.
          vim.api.nvim_set_option("background", "dark")
        end,
      })
    end,
  },
}
