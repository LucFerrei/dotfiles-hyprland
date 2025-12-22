return{
    {
      "brenoprata10/nvim-highlight-colors",
      config = function()
	require("nvim-highlight-colors").setup({
	  render = 'background', -- Opções: 'background', 'foreground' ou 'virtual'
	  enable_named_colors = true,
	  enable_tailwind = true,
	})
      end
    }
}
