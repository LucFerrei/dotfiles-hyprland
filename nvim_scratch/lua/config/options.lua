vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.shiftwidth = 4
vim.opt.clipboard= "unnamedplus"

vim.opt.swapfile = false
;
vim.g.netrw_dirhistmax = 0
vim.g.netrw_browse_split = 0

vim.lsp.config('*', {
    capabilities = require('blink.cmp').get_lsp_capabilities(),
})


vim.diagnostic.config({
  virtual_text = true, -- This enables the inline text
  signs = true,        -- Shows icons in the gutter
  underline = true,    -- Underlines the error in the code
  update_in_insert = false, -- Don't show errors while typing
  severity_sort = true,
})

function toggle_transparency()
    local tranparency_state = require('rose-pine.config').options.styles.transparency
    tranparency_state = not tranparency_state
    require('rose-pine').setup({
	styles = {
	    transparency = tranparency_state
	}
    })
    vim.cmd("colorscheme rose-pine")
end

function toggle_color_mode()
    local variant = require('rose-pine.config').options.variant
    if variant=="main" then
	variant = "dawn"
    else
	variant = "main"
    end
    require('rose-pine').setup({
	variant = variant
    })
    vim.cmd("colorscheme rose-pine")
end
