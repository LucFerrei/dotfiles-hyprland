return {
    "dgox16/oldworld.nvim",
    lazy = false,
    priority = 1000,
    config = function ()
	require("oldworld").setup({
	    terminal_colors = true,
	    transparent = true,
	    variant = "oled",
	    styles = {
		comments = { italic = true },
		keywords = { italic = true, bold = true },
		-- functions = { italic = true, bold = true },
		identifiers = { italic = true }
	    },
	    integrations = {
		neo_tree = true,
		telescope = false,
	    }
	})
	vim.cmd("colorscheme oldworld")
    end
}
-- #sadfsadf
