--core
require("core.keymaps")
require("core.lazyplug.config")
require("core.options")
require("core.colorscheme")
require("core.gui") -- ui use neovide

-- plugins configure
require("plugins.telescope")
require("plugins.treesitter")
require("plugins.neotree")
require("plugins.lualine")
require("plugins.multicursor")
-- require("plugins.smoothcursor") -- cursor
require("plugins.hop")
require("plugins.terminal")
require("plugins.noice")
require("plugins.notify")
require("plugins.comments")
require("plugins.coderunner")
require("plugins.colorizer")
require("plugins.todo")
require("plugins.gitsing")
require("plugins.cinnamon")
require("plugins.cowboy") -- cowboy
require("plugins.indentLine")
require("plugins.yazinvim")
require("plugins.treesitter-context")
require("plugins.lazygit")
require("plugins.scope")
require("plugins.cmp")
require("plugins.scrollview")
require("plugins.dashboard")
require("plugins.illuminate")
require("plugins.matchup")
require("plugins.renamer")
require("plugins.showfile")
--buffer
require("plugins.buffer-name")
require("plugins.buffer-new")
require("plugins.buffer-del")
require("plugins.buffer-line")
require("plugins.buffer-clouse")
require("plugins.pacman_anims")
-- sql
require("plugins.dadbod")
--ai-helper
require("plugins.codeium")

-- snippets
require("snippets.snippets")
require("snippets.pyright")

-- devlanguag
require("devlangs.config")
