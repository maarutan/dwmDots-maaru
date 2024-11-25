-- core configure
require("core.options") -- nvim config
require("core.keymaps") -- keymaps
require("core.autocmds") -- auto complete

-- load plugins 
require("plugins.setup") -- plugins manager
require("plugins.config") -- plugins settings
require("plugins.lualine") 
require("plugins.noice")
require("plugins.catppuccin") 
require("plugins.treesitter")
require("plugins.neotree")
require("plugins.notify")
