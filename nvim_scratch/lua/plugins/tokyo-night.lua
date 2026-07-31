return{
    {
      "folke/tokyonight.nvim",
      lazy = true,
      priority = 1000,
      opts = {},
      config = function()
	  require("tokyonight").setup({
	      style = "moon",
	      transparent = false,
	  })
	  -- vim.cmd("colorscheme tokyonight")
      end
    },
}


