return {
    {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	opts = {
	    options = {
		theme = "auto", -- segue o colorscheme ativo (rose-pine)
		globalstatus = true, -- uma barra só, não uma por janela
		section_separators = "",
		component_separators = "|",
		icons_enabled = true,
	    },
	    sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { { "filename", path = 1 } }, -- caminho relativo, ex: "src/write.rs"
		lualine_x = { "encoding", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	    },
	},
    },
}
