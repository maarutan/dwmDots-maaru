return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy", -- Подгрузка плагина только при необходимости
  config = function()
    require("lualine").setup {
      options = {
        theme = "catppuccin", -- Укажи желаемую тему
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        inverse_separator = { right = "", left = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    }
  end,
}
