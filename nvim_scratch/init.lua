require("config.lazy")
require("config.options")
require("config.keymaps")

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }

    -- Essential Navigation
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)     -- Go to Definition
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)    -- Go to Declaration
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)     -- List References
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts) -- Go to Implementation
    vim.keymap.set('n', 'K',  vim.lsp.buf.hover, opts)          -- Hover Documentation

    -- Refactoring & Actions
    -- vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)      -- Rename Symbol
    -- vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts) -- Code Actions
    -- vim.keymap.set('n', '<leader>f', function()
    --   vim.lsp.buf.format { async = true }
    -- end, opts) -- Format File

    -- Diagnostics (Errors/Warnings)
    -- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts) -- Previous Error
    -- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts) -- Next Error
    -- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts) -- Show line error
  end,
})
