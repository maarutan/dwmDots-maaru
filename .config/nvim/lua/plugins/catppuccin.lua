return {
  {
    "catppuccin/nvim",
    name = "catppuccin", -- Важно для правильного `require`
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- Выбери "mocha", "macchiato", "frappe" или "latte"
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}

