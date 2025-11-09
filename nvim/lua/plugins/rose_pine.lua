return {
  -- Add options to the rose-pine plugin
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      variant = "moon",
      styles = {
        -- Set the background to be transparent
        -- Note: Your terminal emulator must also support transparency.
        transparency = true,
      },
    },
  },

  -- 2. Configure LazyVim to use the colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
}
