local function install_lazy()
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    
    if not vim.loop.fs_stat(lazypath) then
        local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
        if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
                { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
                { out, "WarningMsg" },
                { "\nPress any key to exit...", "WarningMsg" },
            }, true, {})
            vim.fn.getchar()
            os.exit(1)
        end
    end

    vim.opt.rtp:prepend(lazypath)
end

-- Устанавливаем lazy.nvim
install_lazy()

-- Загружаем список плагинов
require("lazy").setup(require("core.lazyplug.install"))

