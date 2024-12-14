-- lua/config/cmp.lua
local cmp = require("cmp")
local luasnip = require("snippets.snippets") -- Подключаем нашу конфигурацию для LuaSnip

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body) -- Использование LuaSnip для сниппетов
		end,
	},

	mapping = {
		-- C-Space для переключения автодополнения
		["<C-Space>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.close() -- Закрыть подсказку
			else
				cmp.complete() -- Включить подсказку
			end
		end, { "i", "c" }),

		-- Tab для подтверждения выбора
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.confirm({ select = true }) -- Подтверждение текущего выбора
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump() -- Развернуть сниппет или перейти вперед
			else
				fallback() -- Обычное поведение
			end
		end, { "i", "s" }),

		-- Shift-Tab для возврата назад
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
				luasnip.jump(-1) -- Перейти назад в сниппете
			else
				fallback() -- Обычное поведение
			end
		end, { "i", "s" }),

		-- C-j / C-k для навигации
		["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),

		-- C-l для подтверждения выбора
		["<C-l>"] = cmp.mapping.confirm({ select = true }),

		-- C-Return для подтверждения выбора
		["<C-Return>"] = cmp.mapping.confirm({ select = true }),

		-- Enter для подтверждения выбора
		["<CR>"] = cmp.mapping.confirm({ select = true }),

		-- Прокрутка документации
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),

		-- Закрытие автодополнения
		["<C-e>"] = cmp.mapping.close(),
	},

	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" }, -- Источник для путей
	}),

	formatting = {
		format = function(entry, vim_item)
			vim_item.menu = ({
				nvim_lsp = "[LSP]",
				buffer = "[Buffer]",
				path = "[Path]",
				codeium = "[Codeium]", -- Добавляем метку для Codeium
				luasnip = "[Snippet]",
			})[entry.source.name]
			return vim_item
		end,
	},

	experimental = {
		ghost_text = true, -- Включение текста-призрака
	},
})

-- Автодополнение только для поиска в буфере (`/`, `?`), но не для команд (`:`)
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" }, -- Источник для буфера
	},
})

-- Исключение `:` из автодополнения
-- Просто не добавляем cmp.setup.cmdline для ':'
