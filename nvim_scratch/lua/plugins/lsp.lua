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
      ensure_installed = { "lua_ls", "pyright", "ts_ls", "html", "clangd" },
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

	vim.lsp.enable('lua_ls')
	vim.lsp.enable('clangd')
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    config = function()
    end,
  },
}
