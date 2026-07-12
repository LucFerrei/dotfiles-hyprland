return {
	'stevearc/conform.nvim',
	enabled = false,
	opts = {
		formatters_by_ft = {
			rust = { "rustfmt" },
		},
		-- Adicione este bloco para formatar ao salvar:
		format_on_save = {
			timeout_ms = 500,  -- Tempo limite para o formatador terminar
			lsp_format = "fallback", -- Tenta o LSP primeiro, se não, usa o rustfmt
		},
	},
}
