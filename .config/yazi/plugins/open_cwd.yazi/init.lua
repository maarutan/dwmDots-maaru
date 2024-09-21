print("Загрузка плагина...")

local function yazi_with_cwd(...)
    local temp_file = os.tmpname()  -- Создает временный файл
    local command = string.format("yazi --cwd-file=%s", temp_file)

    print("Запускаю Yazi...")
    os.execute(command)  -- Запускает Yazi

    local file = io.open(temp_file, "r")  -- Открывает временный файл
    if file then
        local cwd = file:read("*a")  -- Читает содержимое
        file:close()
        
        if cwd and cwd ~= "" then
            print("Возвращаюсь в директорию: " .. cwd)
            os.execute("cd " .. cwd)  -- Переходит в считанную директорию
        end
    end

    os.remove(temp_file)  -- Удаляет временный файл
end

-- Переопределяем команду yazi
yazi = yazi_with_cwd

