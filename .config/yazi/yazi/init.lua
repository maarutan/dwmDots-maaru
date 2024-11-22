require("full-border"):setup()
require("git"):setup()
require("no-status"):setup()
require("eza-preview"):setup()
require("yatline"):setup({
	section_separator = { open = "", close = "" },
	part_separator = { open = "", close = "" },
	inverse_separator = { open = "", close = "" },

	style_a = {
		fg = "#1e1e2e", -- Mocha: Base
		bg_mode = {
			normal = "#b4befe", -- Mocha: Lavender
			select = "#a6e3a1", -- Mocha: Green
			un_set = "#f38ba8", -- Mocha: Red
		},
	},
	style_b = { bg = "#313244", fg = "#cdd6f4" }, -- Mocha: Surface0 and Text
	style_c = { bg = "#1e1e2e", fg = "#b4befe" }, -- Mocha: Base and Lavender

	permissions_t_fg = "#a6e3a1", -- Mocha: Green
	permissions_r_fg = "#fab387", -- Mocha: Peach
	permissions_w_fg = "#f38ba8", -- Mocha: Red
	permissions_x_fg = "#89b4fa", -- Mocha: Blue
	permissions_s_fg = "#585b70", -- Mocha: Overlay0

	tab_width = 20,
	tab_use_inverse = false,

	selected = { icon = "󰻭", fg = "#f9e2af" }, -- Mocha: Yellow
	copied = { icon = "", fg = "#a6e3a1" }, -- Mocha: Green
	cut = { icon = "", fg = "#f38ba8" }, -- Mocha: Red

	total = { icon = "󰮍", fg = "#f9e2af" }, -- Mocha: Yellow
	succ = { icon = "", fg = "#a6e3a1" }, -- Mocha: Green
	fail = { icon = "", fg = "#f38ba8" }, -- Mocha: Red
	found = { icon = "󰮕", fg = "#89b4fa" }, -- Mocha: Blue
	processed = { icon = "󰐍", fg = "#a6e3a1" }, -- Mocha: Green

	show_background = true,

	display_header_line = true,
	display_status_line = true,

	header_line = {
		left = {
			section_a = {
				{ type = "line", custom = false, name = "tabs", params = { "left" } },
			},
			section_b = {},
			section_c = {},
		},
		right = {
			section_a = {
				{ type = "string", custom = false, name = "date", params = { "%A, %d %B %Y" } },
			},
			section_b = {
				{ type = "string", custom = false, name = "date", params = { "%X" } },
			},
			section_c = {},
		},
	},

	status_line = {
		left = {
			section_a = {
				{ type = "string", custom = false, name = "tab_mode" },
			},
			section_b = {
				{ type = "string", custom = false, name = "hovered_size" },
			},
			section_c = {
				{ type = "string", custom = false, name = "hovered_name" },
				{ type = "coloreds", custom = false, name = "count" },
			},
		},
		right = {
			section_a = {
				{ type = "string", custom = false, name = "cursor_position" },
			},
			section_b = {
				{ type = "string", custom = false, name = "cursor_percentage" },
			},
			section_c = {
				{ type = "string", custom = false, name = "hovered_file_extension", params = { true } },
				{ type = "coloreds", custom = false, name = "permissions" },
			},
		},
	},
})
