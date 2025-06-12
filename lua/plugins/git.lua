local enterFileEvent = { "BufReadPost", "BufNewFile", "BufWritePost" }


return {
	{ "lewis6991/gitsigns.nvim", event = enterFileEvent },
	{ "f-person/git-blame.nvim", lazy = true },
	{ "tpope/vim-fugitive", event = "CmdLineEnter" },
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
		config = function()
			vim.g.lazygit_floating_window_scaling_factor = 0.8 -- scaling factor for floating window
		end,
	},
}
