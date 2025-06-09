return {
	"numToStr/comment.nvim",
	"tpope/vim-repeat",
	"tpope/vim-surround",
	"windwp/nvim-autopairs",
	"kyazdani42/nvim-tree.lua",
	"nvim-lualine/lualine.nvim",
	"stevearc/conform.nvim",
	{ "akinsho/toggleterm.nvim", version = "v1.*" },
	"nvim-telescope/telescope-frecency.nvim",
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	},
	{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
	{
		"nvim-neorg/neorg",
		dependencies = { "luarocks.nvim" },
		lazy = false,
		version = "*",
		config = true,
	},
}
