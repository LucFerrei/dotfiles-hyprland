return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",

    -- escolha um picker, se você usa algum:
    "nvim-telescope/telescope.nvim",

    -- opcionais:
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    lang = "rust", -- ou "cpp", "java", "rust", "golang", etc.
  },
}
