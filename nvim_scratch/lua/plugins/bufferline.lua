return{
    {
	'akinsho/bufferline.nvim',
	version = "*",
	dependencies = 'nvim-tree/nvim-web-devicons',
	opts = {
	    options = {
		separator_style = "slant",
		show_buffer_close_icons = false,
		show_close_icon = false,
		diagnostics = "nvim_lsp",
		always_show_bufferline = true,
	    }
	}
    }
}
