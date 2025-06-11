return {
	{ "lewis6991/gitsigns.nvim", event = "VeryLazy" },
	{ "f-person/git-blame.nvim", Lazy = true },
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
	},
}
