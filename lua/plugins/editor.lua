local enterFileEvent = { "BufReadPost", "BufNewFile", "BufWritePost" }

return {
	{ "numToStr/comment.nvim", opts = {}, event = "VeryLazy" },
	{ "tpope/vim-repeat", event = "VeryLazy" },
	{ "tpope/vim-surround", event = "VeryLazy" },
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		priority = 700,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},

		config = function()
			require("nvim-tree").setup({
				git = {
					enable = true,
					timeout = 10000,
				},
				filters = {
					git_ignored = false,
				},
				sync_root_with_cwd = true,
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "f-person/git-blame.nvim" },
		lazy = false,
		priority = 100,
		config = function()
			local git_blame = require("gitblame")
			require("lualine").setup({
				options = {
					theme = "zenburn",
				},
				sections = {
					lualine_c = {
						{
							"filename",
							file_status = true,
							path = 3,
						},
					},
					lualine_x = {
						{ git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
						"ctime",
						"filetype",
					},
				},
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		cmd = { "ConformInfo" },
		keys = {
			{
				-- Customize or remove this keymap to your liking
				"<leader>=",
				function()
					require("conform").format({ async = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		config = function()
			require("conform").setup({
				formatexpr = "v:lua.require'conform'.formatexpr()",
				formatters_by_ft = {
					lua = { "stylua" },
					-- Conform will run multiple formatters sequentially
					python = { "black" },
					javascript = { "prettier" },
					typescriptreact = { "prettier" },
				},
			})
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		keys = {
			{ "<leader>tt", ":ToggleTerm<CR>", desc = "Toggle Terminal" },
		},
		opts = {},
		config = function()
			require("toggleterm").setup()
			local opts = { silent = true, remap = false }
			-- keymaps to help terminal navigation
			local function set_terminal_keymaps()
				local opts = { buffer = 0 }
				vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
				vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
				vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
				vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
				vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
			end

			-- if you only want these mappings for toggle term use term://*toggleterm#* instead
			vim.api.nvim_create_autocmd("TermOpen", { pattern = "term://*", callback = set_terminal_keymaps })
			vim.api.nvim_create_autocmd("TermEnter", {
				pattern = "term://",
				callback = function()
					vim.cmd("startinsert!")
				end,
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-frecency.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
			},
		},
		keys = {
			"<leader>ff",
			"<leader>fg",
			"<leader>fb",
			"<leader>fh",
			"<leader>fr",
			"<leader>ft",
		},
		config = function()
			local opts = { silent = true, remap = false }
			local telescope = require("telescope")
			local tel_built = require("telescope.builtin")
			telescope.load_extension("frecency")

			-- telescope Mappings
			vim.keymap.set("n", "<leader>ff", tel_built.git_files, opts)
			vim.keymap.set("n", "<leader>fF", tel_built.find_files, opts)
			vim.keymap.set("n", "<leader>fg", tel_built.live_grep, opts)
			vim.keymap.set("n", "<leader>fb", tel_built.buffers, opts)
			vim.keymap.set("n", "<leader>fh", tel_built.help_tags, opts)
			vim.keymap.set("n", "<leader>fr", telescope.extensions.frecency.frecency, opts)
		end,
	},
	{
		"nvim-neorg/neorg",
		dependencies = { "luarocks.nvim" },
		ft = ".norg",
		version = "*",
		config = true,
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		event = enterFileEvent,
		config = function()
			vim.o.foldcolumn = "1" -- '0' is not bad
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
			require("ufo").setup()

			-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
			vim.keymap.set("n", "zR", require("ufo").openAllFolds)
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
		end,
	},
    {
        "ggandor/leap.nvim",
        config = function ()
            require('leap').set_default_mappings()
        end
    }
{    "nvim-treesitter/nvim-treesitter-context",
    opts = {},
    event = enterFileEvent,
}
}
