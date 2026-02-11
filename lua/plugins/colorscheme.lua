return {
  -- Themery - theme switcher
  {
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
      require("themery").setup({
        themes = {
          "tokyonight-night",
          "tokyonight-storm",
          "tokyonight-moon",
          "catppuccin-mocha",
          "catppuccin-macchiato",
          "catppuccin-frappe",
          "gruvbox",
          "kanagawa",
          "rose-pine",
          "nord",
          "onedark",
        },
        livePreview = true, -- Preview theme while browsing
      })
      
      -- Keybind to open theme switcher
      vim.keymap.set("n", "<leader>th", ":Themery<CR>", { desc = "Theme switcher" })
    end,
  },

  -- Colorschemes
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
  { "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 1000 },
  { "ellisonleao/gruvbox.nvim", lazy = false, priority = 1000 },
  { "rebelot/kanagawa.nvim", lazy = false, priority = 1000 },
  { "rose-pine/neovim", name = "rose-pine", lazy = false, priority = 1000 },
  { "shaunsingh/nord.nvim", lazy = false, priority = 1000 },
  { "navarasu/onedark.nvim", lazy = false, priority = 1000 },
}
