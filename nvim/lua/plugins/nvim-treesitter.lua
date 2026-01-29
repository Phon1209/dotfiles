return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local config = require("nvim-treesitter.configs")
			config.setup({
				auto_install = true,
				ensure_installed = {
					"lua",
					"astro",
					"typescript",
					"javascript",
					"tsx",
					"html",
					"css",
				},
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
}
