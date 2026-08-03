return {
    "LucFerrei/vespera.nvim", -- ou dir = "~/personal/vespera.nvim"
    lazy = true,
    priority = 1000,
    config = function()
        require("vespera").setup()
        -- vim.cmd("colorscheme vespera")
    end,
}
