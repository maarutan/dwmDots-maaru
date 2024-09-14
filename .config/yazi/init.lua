require("full-border"):setup()
require("git"):setup()
require("no-status"):setup()
require("eza-preview"):setup()
require("yatline"):setup({
	section_separator = { open = "", close = "" },
	part_separator = { open = "", close = "" },
	inverse_separator = { open = "", close = "" },

	style_a = {
		fg = "#f8f8f2", -- белый цвет текста
		bg_mode = {
			normal = "#a986e1", -- фон по умолчанию
			select = "#91dee1", -- фон для выбранного
			un_set = "#dfdf96" -- фон для не выбранного
		}
	},
	style_b = { bg = "#363655", fg = "#b699fd" }, -- тёмный фон и белый текст
	style_c = { bg = "#1f2031", fg = "#f8f8f2" }, -- тёмный фон и белый текст

	permissions_t_fg = "#8be9fd", -- зелёный
	permissions_r_fg = "#f1fa8c", -- жёлтый
	permissions_w_fg = "#ff5555", -- красный
	permissions_x_fg = "#8be9fd", -- голубой
	permissions_s_fg = "#6272a4", -- тёмно-синий

	tab_width = 20,
	tab_use_inverse = false,

	selected = { icon = "󰻭", fg = "#f1fa8c" }, -- жёлтый
	copied = { icon = "", fg = "#8be9fd" }, -- голубой
	cut = { icon = "", fg = "#ff5555" }, -- красный

	total = { icon = "󰮍", fg = "#f1fa8c" }, -- жёлтый
	succ = { icon = "", fg = "#8be9fd" }, -- зелёный
	fail = { icon = "", fg = "#ff5555" }, -- красный
	found = { icon = "󰮕", fg = "#bd93f9" }, -- синий
	processed = { icon = "󰐍", fg = "#8be9fd" }, -- зелёный

	show_background = true,

	display_header_line = true,
	display_status_line = true,

	header_line = {
		left = {
			section_a = {
			},
			section_b = {
			},
			section_c = {
			}
		},
		right = {
			section_a = {
			},
			section_b = {
			},
			section_c = {
			}
		}
	},
	status_line = {
		left = {
			section_a = {
        			{type = "string", custom = false, name = "tab_mode"},
			},
			section_b = {
        			{type = "string", custom = false, name = "hovered_size"},
			},
			section_c = {
        			{type = "string", custom = false, name = "hovered_name"},
			}
		},
		right = {
			section_a = {
        			{type = "string", custom = false, name = "cursor_position"},
			},
			section_b = {
        			{type = "string", custom = false, name = "cursor_percentage"},
			},
			section_c = {
        			{type = "coloreds", custom = false, name = "permissions"},
			}
		}
	},
})

