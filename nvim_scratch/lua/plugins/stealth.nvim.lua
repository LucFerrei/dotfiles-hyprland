return {
  "LucFerrei/stealth.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    variant = "monochrome",
    transparent = true,
    styles = {
      comments = { italic = true },
      keywords = { bold = true },
    },
  },
  config = function(_, opts)
    require("stealth").setup(opts)
    -- vim.cmd.colorscheme("stealth")
  end,
}
