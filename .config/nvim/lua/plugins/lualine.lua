return {
  {
    "nvim-lualine/lualine.nvim",
    lazy = false, -- Загружать сразу
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- Иконки (опционально)
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin", -- Замени на свою тему
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          globalstatus = true, -- Включить глобальную строку состояния
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
      })
    end,
  },
}

