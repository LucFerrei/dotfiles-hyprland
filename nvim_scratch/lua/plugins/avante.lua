-- lua/plugins/avante.lua
return {
  "yetone/avante.nvim",
  build = "make",
  event = "VeryLazy",
  version = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    provider = "deepseek",
    providers = {
      deepseek = {
        __inherited_from = "openai",
        api_key_name     = "DEEPSEEK_API_KEY",
        endpoint         = "https://api.deepseek.com/v1",
        model            = "deepseek-v4-flash",
        extra_request_body = {
          temperature = 0.3, -- recomendado pela DeepSeek para coding
          max_tokens  = 8192,
        },
      },
    },
  },
}
