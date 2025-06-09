return {
	{ "numToStr/comment.nvim", opts = {}, event = "VeryLazy" },
	{ "tpope/vim-repeat", event = "VeryLazy" },
	{ "tpope/vim-surround", event = "VeryLazy" },
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		Lazy = "false",
		Priority = 700,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup({})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "f-person/git-blame.nvim" },
		Lazy = "false",
		Priority = 100,
		config = function()
			local git_blame = require("gitblame")
			require("lualine").setup({
                options = {
                    theme = "zenburn"
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
			{ "<leader>gg" },
		},
		opts = {},
		config = function()
			require("toggleterm").setup()
			local opts = { silent = true, remap = false }
			local Terminal = require("toggleterm.terminal").Terminal
			local lazygit = Terminal:new({
				cmd = "lazygit",
				hidden = true,
				direction = "float",
				on_open = function(term)
					vim.cmd("startinsert!")
					-- since escape has functionality in the window delete it
					vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<Esc>", "<Nop", { noremap = true, silent = true }
)
					-- since we still want a way to quit the application
					vim.api.nvim_buf_set_keymap(
						term.bufnr,
						"t",
						"<C-q>",
						"<cmd>close<CR>",
						{ noremap = true, silent = true }
					)
					vim.api.nvim_buf_set_keymap(
						term.bufnr,
						"t",
						"<C-c>",
						"<cmd>close<CR>",
						{ noremap = true, silent = true }
					)
				end,
			})

			function lazygit_toggle()
				lazygit:toggle()
			end

			vim.keymap.set("n", "<leader>gg", lazygit_toggle, opts)
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
}
