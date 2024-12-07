require("devlangs.formatters.prettier") -- Используй prettier, установленный через Mason
require("devlangs.formatters.black")    -- Используй black, установленный через Mason
require("devlangs.formatters.stylua")   -- Используй stylua

-- установленный через Mason

local null_ls = require("null-ls")

-- Настройка форматтеров
null_ls.setup({
   on_attach = function(client, bufnr)
      if client.server_capabilities.documentFormattingProvider then
         -- Автоматическое форматирование при сохранении
         vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
               vim.lsp.buf.format({ async = false })
            end,
         })
      end
   end,
})
