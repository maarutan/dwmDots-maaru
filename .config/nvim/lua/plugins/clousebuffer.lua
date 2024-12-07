function CloseBufferWithNoDelay()
  -- Временно устанавливаем timeoutlen = 0 для ускорения работы с клавишами
  vim.opt.timeoutlen = 0

  -- Получаем количество активных буферов
  local buf_count = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.buflisted(buf) == 1 then
      buf_count = buf_count + 1
    end
  end

  -- Если буферов больше одного, закрываем текущий
  if buf_count > 1 then
    vim.cmd('silent! bnext')  -- Переключиться на следующий буфер
    vim.cmd('silent! bd')     -- Закрыть текущий буфер
  else
    -- Если только один буфер, закрываем окно
    vim.cmd('quit')  -- Закрыть окно, завершить сессию
  end

  -- Принудительно обновляем экран, чтобы убрать задержку
  vim.cmd('redraw')  -- Принудительно обновить интерфейс

  -- Немедленно восстанавливаем значение timeoutlen обратно
  vim.opt.timeoutlen = original_timeoutlen
end

