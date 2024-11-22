if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "python",
      "html",
      "css",
      "javascript",
      "typescript",
      "rust",
      "json",
      "yaml",
      "toml",
      "bash",
      "c",
      -- add more arguments for adding more treesitter parsers
    },
  },
}
