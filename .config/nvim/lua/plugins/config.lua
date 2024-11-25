return {
    { "nvim-lualine/lualine.nvim" },
    { "catppuccin/nvim",  },
    { "nvim-treesitter/nvim-treesitter",build = ":TSUpdate"},
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x", 
        dependencies = {
            "nvim-lua/plenary.nvim", 
        },
    },
    { "MunifTanjim/nui.nvim" },
    { "nvim-tree/nvim-web-devicons", },
    { "folke/noice.nvim"      },
    { "rcarriga/nvim-notify"  },
    {
    "Exafunction/codeium.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
    },
    config = function()
        require("codeium").setup({
        })
    end
    },
}


