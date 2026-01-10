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
    -- Rust setup (The "Standalone" fix)
	vim.lsp.config('rust_analyzer', {
	  cmd = {'rust-analyzer'},
	  filetypes = {'rust'},
	  -- Adding '.' allows it to attach even if there is no Cargo.toml
	  root_markers = {'Cargo.toml', 'rust-project.json', '.git', '.'},
	  settings = {
	    ['rust-analyzer'] = {
	      -- This helps with standalone file diagnostics
	      checkOnSabe = false,
	      -- procMacro { enable = true },
	      cargo = {
		loadOutDirsFromCheck = false,
	      },
	    imports = {
		granularity = { group = "module" },
		prefix = "self",
	    },
	    }
	  }
	})
	vim.lsp.enable('lua_ls')
	vim.lsp.enable('clangd')
	vim.lsp.enable('rust_analyzer')
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    config = function()
    end,
  },
}
