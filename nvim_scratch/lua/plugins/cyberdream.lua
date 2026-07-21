return{
    {
	"scottmckendry/cyberdream.nvim",
	lazy = true, -- rose-pine é o tema de startup; carrega só se ativado via :colorscheme
	config = function ()
	    require("cyberdream").setup({
		variant = "light",
		transparent = false,
		saturation = 1,
	    })
	    vim.cmd("colorscheme cyberdream")
	end,
    }
}
