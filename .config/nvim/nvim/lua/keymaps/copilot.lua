vim.keymap.set(
  "i",
  "<Tab>",
  function() return vim.fn["copilot#Accept"] "" end,
  { expr = true, silent = true, desc = "Accept Copilot suggestion" }
)
