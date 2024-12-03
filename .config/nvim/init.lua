--core
require("core.keymaps") 
require("core.lazyplug.config")
require('core.options')
require("core.colorscheme")

-- plugins configure
require("plugins.telescope")
require("plugins.treesitter")
require("plugins.neotree") 
require("plugins.lualine")
--require("plugins.multicursor")
require("plugins.bufferline")
require("plugins.smoothcursor")
require("plugins.hop")
require("plugins.terminal")
require("plugins.noice")
require("plugins.notify")
require("plugins.comments")
require("plugins.clousebuffer")
require("plugins.coderunner")
require("plugins.colorizer")
require("plugins.todo")
require("plugins.gitsing")
require("plugins.cinnamon")
require("plugins.cowboy")
require("plugins.indentLine")
require("plugins.yazinvim")
require("plugins.treesitter-context")
require("plugins.lazygit")
require("plugins.mason")
require("plugins.scope")
require("plugins.cmp")
require("plugins.scrollview")
require("plugins.dashboard")
--ai-helper
require("plugins.codeium")

-- snippets
require("snippets.snippets")
require("snippets.pyright")

-- devlanguag
require("devlangs.config")
