return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
	window = {
	    position = "left",
	    width = 30,
	},
      filesystem = {
        hijack_netrw_behavior = "open_default", -- Importante para não conflitar
        use_libuv_file_watcher = true,          -- Atualiza a árvore se o Oil mudar algo
      }
    })
  end
}
