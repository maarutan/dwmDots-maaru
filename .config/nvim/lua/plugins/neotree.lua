-- Определение значков диагностики
vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

-- Настройка Neo-tree
require("neo-tree").setup({
	close_if_last_window = true,
	sources = {
		"filesystem", -- источник для файлов
		"git_status", -- источник для статуса Git
	},
	source_selector = {
		winbar = true, -- показывать в строке состояния
		statusline = false, -- не показывать в строке состояния
		content_layout = "two_horizontal", -- расположение источников
	},
	window = {
		position = "left", -- Позиция окна
		width = 25, -- Ширина окна
		mappings = {
			["h"] = function(state)
				local node = state.tree:get_node()
				if node.type == "directory" and node:is_expanded() then
					require("neo-tree.sources.filesystem").toggle_directory(state, node)
				else
					require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
				end
			end,
			["l"] = function(state)
				local node = state.tree:get_node()
				local path = node:get_id()
				if node.type == "directory" then
					if not node:is_expanded() then
						require("neo-tree.sources.filesystem").toggle_directory(state, node)
					elseif node:has_children() then
						require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
					end
				elseif node.type == "file" then
					require("neo-tree.utils").open_file(state, path)
				end
			end,
			["e"] = function()
				vim.api.nvim_exec("Neotree focus filesystem left", true)
			end,
			["g"] = function()
				vim.api.nvim_exec("Neotree focus git_status left", true)
			end,
		},
	},
	filesystem = {
		follow_current_file = true, -- следить за текущим файлом
	},
	git_status = {
		enable = true, -- включить статус Git
		show_untracked = true, -- показывать неотслеживаемые файлы
	},
})
