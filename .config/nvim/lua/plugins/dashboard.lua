local function default_header()
	return {
		"",
		"",
		"",
		"███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
		"████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
		"██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
		"██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
		"██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
		"╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
		"",
		"",
		"",
	}
end

require("dashboard").setup({
	theme = "doom",
	config = {
		header = default_header(),
		center = {
			{
				icon = "󰙅 ",
				icon_hl = "Title",
				desc = "Open tree",
				desc_hl = "String",
				key = "e",
				keymap = "            SPC e _",
				key_hl = "Number",
				action = ":NeoTreeFocus",
			},
			{
				icon = "󰈞 ",
				icon_hl = "Title",
				desc = "Find files",
				desc_hl = "String",
				key = "f",
				keymap = "              SPC f f",
				key_hl = "Number",
				action = ":Telescope find_files",
			},
			{
				icon = " ",
				icon_hl = "Title",
				desc = "Find text",
				desc_hl = "String",
				key = "w",
				keymap = "              SPC f w",
				key_hl = "Number",
				action = ":Telescope live_grep",
			},
			{
				icon = " ",
				icon_hl = "Title",
				desc = "Git Branches",
				desc_hl = "String",
				key = "b",
				keymap = "              SPC g b",
				key_hl = "Number",
				action = ":Telescope git_branches",
			},
			{
				icon = "󰄛 ",
				icon_hl = "Title",
				desc = "Recent files",
				desc_hl = "String",
				key = "r",
				keymap = "              SPC f r",
				key_hl = "Number",
				action = ":Telescope oldfiles",
			},
			{
				icon = " ",
				icon_hl = "Title",
				desc = "New file",
				desc_hl = "String",
				key = "n",
				keymap = "            SPC n _",
				key_hl = "Number",
				action = ":ene | startinsert",
			},
			{
				icon = " ",
				icon_hl = "Title",
				desc = "Open Neovim Config",
				desc_hl = "String",
				key = "o",
				keymap = "              SPC o c",
				key_hl = "Number",
				action = ":cd ~/.config/nvim | edit init.lua",
			},
			-- Кнопка Quit [q]
			{
				desc = "                    󰩈 Quit [q]", -- Центрируем текст
				desc_hl = "String",
				key = "q",
				keymap = "            SPC q _",
				key_hl = "Number",
				action = ":qa", -- Команда выхода из Neovim
			},
		},
		footer = { "Welcome to Neovim 🚀" }, -- Футер
	},
})
