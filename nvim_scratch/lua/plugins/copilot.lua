return {
  "zbirenbaum/copilot.lua",
  requires = {
    "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
  },
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require('copilot').setup({
      -- Configurações do módulo de sugestões (ghost text)
      suggestion = {
	enabled = true,
	auto_trigger = true, -- Muda para true para as sugestões aparecerem sozinhas ao digitar
	debounce = 75,
	keymap = {
	  accept = "<C-y>",      -- Muda para <Tab> para aceitar (ou deixe "<M-l>" para Alt+L)
	  accept_word = false,
	  accept_line = false,
	  next = "<M-]>",        -- Alt + ] para ir para a próxima sugestão
	  prev = "<M-[>",        -- Alt + [ para ir para a sugestão anterior
	  dismiss = "<C-]>",     -- Ctrl + ] para dispensar a sugestão
	},
      },
      
      -- Configura em quais tipos de arquivo o Copilot deve "atachar" automaticamente
      filetypes = {
	yaml = false,
	markdown = false,
	help = false,
	gitcommit = false,
	gitrebase = false,
	["."] = false,
	["*"] = true, -- O "*" define que ele vai ligar automaticamente para todo o resto
      },
    })
  end,
}
