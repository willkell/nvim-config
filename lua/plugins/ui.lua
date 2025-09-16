return {
	{ "kyazdani42/nvim-web-devicons", Lazy = "true" },
	-- {
	-- 	"phha/zenburn.nvim",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("zenburn").setup()
	-- 		vim.cmd([[colorscheme zenburn]])
	-- 	end,
	-- },
	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	opts = {},
	-- 	config = function()
	-- 		vim.cmd([[colorscheme tokyonight]])
	-- 	end,
	-- },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				integrations = {
					alpha = true,
					blink_cmp = {
						style = "bordered",
					},
					leap = true,
					mason = true,
					neotree = true,
					dap = true,
					dap_ui = true,
					nvim_surround = true,
					ufo = true,
					rainbow_delimiters = true,
					telescope = {
						enabled = true,
					},
					lsp_trouble = true,
					indent_blankline = {
						enabled = true,
						scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
						colored_indent_levels = false,
					},
				},
			})
			vim.cmd([[colorscheme catppuccin]])
		end,
	},
}
