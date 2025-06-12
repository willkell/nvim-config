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
	{
		"folke/snacks.nvim",
		opts = {
			bigfile = { enabled = true },
			quickfile = { enabled = true },
			statuscolumn = {
				left = { "mark", "sign" }, -- priority of signs on the left (high to low)
				right = { "fold", "git" }, -- priority of signs on the right (high to low)
				folds = {
					open = false, -- show open fold icons
					git_hl = false, -- use Git Signs hl for fold icons
				},
				git = {
					-- patterns to match Git signs
					patterns = { "GitSign", "MiniDiffSign" },
				},
				refresh = 50, -- refresh at most every 50ms
			},
		},
		lazy = false,
        priority = 1000,
    -- stylua: ignore
        keys = {
          { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
          { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
          { "<leader>dps", function() Snacks.profiler.scratch() end, desc = "Profiler Scratch Buffer" },
        },
	},
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {},
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>qS", function() require("persistence").select() end,desc = "Select Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
	},
}
