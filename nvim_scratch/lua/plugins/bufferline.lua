return{
    {
	'akinsho/bufferline.nvim',
	version = "*",
	dependencies = 'nvim-tree/nvim-web-devicons',
	opts = {
	    options = {
		indicator = {
		    style = 'underline',
		},
		buffer_close_icon = '󰅖',
		modified_icon = '● ',
		close_icon = ' ',
		left_trunc_marker = ' ',
		right_trunc_marker = ' ',
		separator_style = {'', ''},
		show_buffer_close_icons = false,
		show_close_icon = false,
		diagnostics = "nvim_lsp",
		always_show_bufferline = true,
	    },
	    highlights = {
		indicator_selected = {
		    fg = '#9ccfd8',
		},
		buffer_selected = {
		    sp = '#9ccfd8',
		    underline = true,
		},
		separator = {
		    fg = '#232136',
		    bg = '#232136',
		},
		separator_selected = {
		    fg = '#232136',
		    bg = '#232136',
		},
		separator_visible = {
		    fg = '#232136',
		    bg = '#232136',
		},
	    },
	}
    }
}
