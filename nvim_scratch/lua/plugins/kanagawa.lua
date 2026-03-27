return {
    {
	"rebelot/kanagawa.nvim",
	name = "kanagawa",
	-- priority = 1000,
	config = function ()
	    require('kanagawa').setup({
		compile = true,
		transparent = false,
		colors = {
		    palette = {
		    },
		    theme = {
			all = {
			    ui = {
				bg_gutter = "none",
				float = { bg = "none" }
			    }
			},
			dragon = {
			    syn = {
			    }
			}
		    }
		},
		overrides = function(colors)
		    local theme = colors.theme
		    return {
			Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },  -- add `blend = vim.o.pumblend` to enable transparency
			PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
			PmenuSbar = { bg = theme.ui.bg_m1 },
			PmenuThumb = { bg = theme.ui.bg_p2 },
		    }
		end,
		theme = "wave",
		background = {
		    dark = "wave",
		    light = "lotus"
		}
	    })
	    -- vim.cmd("colorscheme kanagawa")
	end
    }
}
