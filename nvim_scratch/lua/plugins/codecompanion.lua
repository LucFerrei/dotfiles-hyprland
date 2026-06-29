-- lua/plugins/codecompanion.lua
return {
  "olimorris/codecompanion.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
  },
  opts = {
    adapters = {
      deepseek = function()
        return require("codecompanion.adapters").extend("openai_compatible", {
          env = {
            url = "https://api.deepseek.com",
            api_key = "DEEPSEEK_API_KEY", -- nome da env var
          },
          schema = {
            model = {
              default = "deepseek-v4-flash",
            },
          },
        })
      end,
    },
    strategies = {
      chat    = { adapter = "deepseek" },
      inline  = { adapter = "deepseek" },
      agent   = { adapter = "deepseek" },
    },
  },
  keys = {
    { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>",  desc = "AI Chat" },
    { "<leader>ai", "<cmd>CodeCompanion<cr>",             desc = "AI Inline", mode = { "n", "v" } },
    { "<leader>aa", "<cmd>CodeCompanionActions<cr>",      desc = "AI Actions", mode = { "n", "v" } },
  },
}
