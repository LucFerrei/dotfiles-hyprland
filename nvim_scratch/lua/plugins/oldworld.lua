return {
    "dgox16/oldworld.nvim",
    lazy = false,
    priority = 1000,
    config = function ()
	require("oldworld").setup({
	    terminal_colors = true,
	    variant = "oled",
	    styles = {
		comments = { italic = true },
		keywords = { italic = true, bold = true },
		-- functions = { italic = true, bold = true },
		-- identifiers = { italic = true, bold = true }
	    },
	    integrations = {
		neo_tree = false,
		telescope = false,
	    }
	})
	vim.cmd("colorscheme oldworld")
    end
}
-- #sadfsadf
