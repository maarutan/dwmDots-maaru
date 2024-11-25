require("nvim-treesitter.configs").setup({
    ensure_installed = { -- Языки, которые ты используешь
        "python",
        "javascript",
        "typescript",
        "html",
        "css",
        "lua",
        "bash",
        "c",
        "cpp",
        "dockerfile",
        "json",
        "yaml",
    },
    highlight = {
        enable = true, -- Включить подсветку
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true, -- Автоотступы (работает не для всех языков)
    },
    incremental_selection = {
        enable = true, -- Выделение кода блоками
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
})

