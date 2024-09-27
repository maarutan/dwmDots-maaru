require("lazy").setup({
	-- hop.nvim
	{ "phaazon/hop.nvim" }, -- neo-tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
	}, -- syntax highlighting
	{ "nvim-treesitter/nvim-treesitter" }, -- colorscheme
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 }, -- cmp plugins
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "hrsh7th/cmp-cmdline" },
	{ "hrsh7th/nvim-cmp" }, -- Git integration
	{ "lewis6991/gitsigns.nvim" }, -- Mason LSP
	{ "williamboman/mason.nvim" }, -- LSP Config
	{ "neovim/nvim-lspconfig" }, -- Telescope
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{ "jose-elias-alvarez/null-ls.nvim" },
	{ "norcalli/nvim-colorizer.lua" },
	{ "terrortylor/nvim-comment" },
	{ "lewis6991/gitsigns.nvim" },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{ "fraso-dev/nvim-listchars" },
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		-- use opts = {} for passing setup options
		-- this is equivalent to setup({}) function
	},
	{ "windwp/nvim-ts-autotag" },
})
