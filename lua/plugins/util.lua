return {
	"nvim-lua/plenary.nvim",
	{
		"dstein64/vim-startuptime",
		cmd = "StartupTime",

		init = function()
			vim.g.startuptime_tries = 10
		end,
	},
	"ellisonleao/dotenv.nvim",
	{ "vhyrro/luarocks.nvim", priority = 1000, config = true },
}
