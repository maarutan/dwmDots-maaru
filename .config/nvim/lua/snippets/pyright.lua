local luasnip = require("luasnip")
local uv = vim.loop

-- Функция для поиска директории виртуальной среды
local function find_virtual_env()
	local venvs = { ".venv", "venv", "env" }
	for _, venv in ipairs(venvs) do
		if uv.fs_stat(venv) then
			return venv
		end
	end
	return nil
end

-- Добавляем сниппет
luasnip.add_snippets("json", {
	luasnip.snippet("pyrightconfig", {
		luasnip.function_node(function()
			local venv = find_virtual_env() or "venv" -- Используем "venv" по умолчанию
			return {
				"{",
				'  "venvPath": "./",',
				'  "venv": "' .. venv .. '",',
				'  "pythonPath": "./' .. venv .. '/bin/python",', -- Для Linux/MacOS
				'  "exclude": [',
				'    "**/node_modules",',
				'    "**/__pycache__"',
				"  ]",
				"}",
			}
		end),
	}),
})
