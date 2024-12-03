require('bufferline').setup {
  options = {
    numbers = "none",
    close_command = 'bdelete',
    right_mouse_command = 'bdelete!',
    left_mouse_command = 'buffer',
    middle_mouse_command = nil,
    indicator = {
      icon = " ▌ ",  -- Мини-блок для активного окна
      style = 'icon',
      fg = '#8AADF4',  -- Белый цвет для индикатора
    },    buffer_close_icon = '  ',
    modified_icon = '[+]',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    max_name_length = 18,
    max_prefix_length = 15,
    tab_size = 18,
    diagnostics = false,
    offsets = {
      {
        filetype = "neo-tree",
        text = "",
        text_align = "center",
      }
    },
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_tab_indicators = true,
    persist_buffer_sort = true,
    separator_style = "thin",
    enforce_regular_tabs = false,
    always_show_bufferline = true,
    custom_areas = {
      right = function()
        return {
          {
            text = "│",  -- Текст для другой кнопки
            -- fg = '#ffffff',
            -- bg = '#1E1E2E',  -- Цвет текста
          },
          {
            text = " 🌊🌊🌊 ",  -- Текст для другой кнопки
            -- fg = '#1E1E2E',
            -- bg = '#1E1E2E',
            padding = 1,  -- Отступ
          },
           {
            text = "  ",  -- Текст для кнопки закрытия
            fg = '#1E1E2E',  -- Цвет текста
            bg = '#b50000',  -- Цвет фона для кнопки закрытия
            padding = 1,  -- Отступ
          },
        }
      end,

      -- Если хотите добавить еще секции, это нужно делать здесь.
    },
  },
}

