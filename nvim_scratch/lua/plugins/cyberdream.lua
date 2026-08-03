return{
    {
	"scottmckendry/cyberdream.nvim",
	lazy = true,
	priority = 1000,
	options = function ()
	    require("cyberdream").setup({
		variant = "light",
		transparent = false,
		saturation = 1,
	    })
	    vim.cmd("colorscheme cyberdream")
	end,
    }
}
