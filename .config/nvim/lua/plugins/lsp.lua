local lspconfig = require('lspconfig')

-- Настройка для Python (с Django)
lspconfig.pylsp.setup{
    settings = {
        pylsp = {
            plugins = {
                flake8 = { enabled = true },  -- Линтер
                pyflakes = { enabled = false },
                pylint = { enabled = true },   -- Линтер для Django
                black = { enabled = true },     -- Форматирование
                autopep8 = { enabled = false },
                yapf = { enabled = false },
                django = { enabled = true },
            },
        },
    },
}

-- Настройка для HTML
lspconfig.html.setup{}

-- Настройка для CSS
lspconfig.cssls.setup{}

-- Настройка для JavaScript/TypeScript (включает JSX и TSX)
lspconfig.tsserver.setup{
    on_attach = function(client, bufnr)
        -- Отключить форматирование от tsserver, если используете другие инструменты форматирования
        client.resolved_capabilities.document_formatting = false
    end,
}

