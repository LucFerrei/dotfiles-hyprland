return {
	"LucFerrei/Vespera",
	name = "vespera",
	lazy = false,
	priority = 1000,
	config = function()
		require("vespera").setup({
			transparent = true,
			styles = {
				comments = { italic = true },
			},
		})
		vim.cmd("colorscheme vespera")
	end,
}
