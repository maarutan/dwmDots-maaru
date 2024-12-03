require('lualine').setup {
  options = {
    icons_enabled = true,        -- Включить иконки
    theme = 'auto',              -- Тема
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      winbar = {},               -- Отключённые типы для winbar
    },
    ignore_focus = {'neo-tree'}, -- Игнорируем фокус в neo-tree
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = true,         -- Включаем общую статус-линию
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {
      { 'branch', icon = '' },
      { 'diff', icon = '' },
      { 'diagnostics', icon = '' }
    },
    lualine_c = {
      'filename',
      function()
        return '🌊🌊🌊'
      end,
    },
    lualine_x = {
      function()
        return  "🌊🌊🌊" -- Пример
      end,
      function()
        return  " " -- Пример
      end,

      'fileformat', 'filetype'
    },
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

