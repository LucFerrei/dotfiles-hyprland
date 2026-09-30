return {
  -- 1. Mason Base
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },

  -- 2. Mason-LSPConfig Bridge
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      -- List the servers you want automatically installed
      -- ensure_installed = { "lua_ls", "pyright", "ts_ls", "html", },
      ensure_installed = {  },
    },
  },

  -- 3. LSPConfig (The actual connection)
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
	vim.lsp.config('lua_ls',{
	    cmd = {'lua-language-server'},
	    filetypes = {'lua'},
	    root_markers = {'git', 'init.lua'},
	    settings = {
		Lua = {
		    diagnostics = {globals = {'vim'}}
		}
	    },
	})

      vim.lsp.config('rust_analyzer', {
        settings = {
          ['rust-analyzer'] = {
            check = { command = 'clippy' },
          },
        },
      })

	vim.lsp.enable({ 'lua_ls', 'clangd', 'rust_analyzer' })
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    config = function()
    end,
  },
}
