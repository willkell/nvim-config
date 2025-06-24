return {
	{
		"goolord/alpha-nvim",
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")
			dashboard.section.buttons.val = {
				dashboard.button("e", "   New file", ":enew <CR>"),
				dashboard.button("SPC f f", "   Find file"),
				dashboard.button("SPC f r", "   Recent files"),
				dashboard.button("SPC e n", "   Edit Config"),
				dashboard.button("SPC f h", "   Help"),
				dashboard.button("q", "   Quit NVIM", ":qa<CR>"),
			}
			alpha.setup(dashboard.config)
		end,
	},
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
					gitsigns = true,
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
				},
			})
			vim.cmd([[colorscheme catppuccin]])
		end,
	},
}
