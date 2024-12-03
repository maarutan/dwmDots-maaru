-- Настройка плагина 'code_runner.nvim'
require('code_runner').setup({
  filetype = {
    -- Настройка для Java
    java = {
      -- Переход в директорию с файлом, компиляция и запуск программы
      "cd $dir &&",            -- Перехожу в директорию с файлом
      "javac $fileName &&",    -- Компилирую Java файл
      "java $fileNameWithoutExt"  -- Запускаю скомпилированный файл без расширения
    },

    -- Настройка для Python
    python = "python3 -u",  -- Для Python используем команду 'python3 -u', где '-u' используется для корректного вывода данных

    -- Настройка для TypeScript с использованием Deno
    typescript = "deno run",  -- Запуск через Deno, т.к. он natively поддерживает TypeScript

    -- Настройка для Rust
    rust = {
      "cd $dir &&",            -- Переход в директорию с файлом
      "rustc $fileName &&",    -- Компиляция исходного кода
      "$dir/$fileNameWithoutExt"  -- Запуск скомпилированного файла
    },

    -- Настройка для C
    c = function()
      -- Основной блок команд для компиляции C программы
      local c_base = {
        "cd $dir &&",              -- Переход в директорию с файлом
        "gcc $fileName -o",        -- Компиляция с использованием gcc (gcc $fileName -o output)
        "/tmp/$fileNameWithoutExt",  -- Сохранение исполнимого файла во временную папку /tmp
      }

      -- Дополнительные команды для выполнения и удаления временного исполнимого файла
      local c_exec = {
        "&& /tmp/$fileNameWithoutExt &&",  -- Запуск исполнимого файла
        "rm /tmp/$fileNameWithoutExt",    -- Удаление временного исполнимого файла после выполнения
      }

      -- Запрос на ввод дополнительных аргументов для компилятора
      vim.ui.input({ prompt = "Add more args:" }, function(input)
        -- Если пользователь ввел какие-либо аргументы
        if input then
          c_base[4] = input  -- Добавляем аргументы в команду компиляции
          -- Логируем команду для отладки (по желанию)
          vim.print(vim.tbl_extend("force", c_base, c_exec))
          
          -- Запускаем команду с аргументами, использующимися для компиляции и исполнения
          require("code_runner.commands").run_from_fn(vim.list_extend(c_base, c_exec))
        end
      end)
    end,
  },
})


-- Настройка горячих клавиш для запуска кода
vim.api.nvim_set_keymap('n', '<A-S-r>', ':RunCode<CR>:lua vim.fn.feedkeys("i")<CR>', { noremap = true, silent = true })

