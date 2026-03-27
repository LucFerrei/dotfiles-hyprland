return {
    {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = true,
    },

    {
	"lewis6991/gitsigns.nvim",
    },

    {
      "folke/todo-comments.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = {
	-- your configuration comes here
	-- or leave it empty to use the default settings
	-- refer to the configuration section below
	option = function ()
	    require("todo-comments").setup({
	      keywords = {
		DONE = { icon = " ", color = "info" }, -- 'info' maps to a green/blue color
	      },
	    })
	end
      }
    }
}
