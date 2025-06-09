return {
	"nvim-lua/plenary.nvim",
	{
		"dstein64/vim-startuptime",
		cmd = "StartupTime",

		init = function()
			vim.g.startuptime_tries = 10
		end,
	},
	{
		"ellisonleao/dotenv.nvim",
		config = function()
			require("dotenv").setup({
				enable_on_load = true,
			})
		end,
	},
	{ "vhyrro/luarocks.nvim", priority = 1000, config = true },
}
