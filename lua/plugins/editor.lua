local enterFileEvent = { "BufReadPost", "BufNewFile", "BufWritePost" }

return {
	{ "numToStr/comment.nvim", opts = {}, event = "VeryLazy" },
	{ "tpope/vim-repeat", event = "VeryLazy" },
	{ "tpope/vim-surround", event = "VeryLazy" },
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		cmd = "Neotree",
		keys = {
			{
				"<leader>tf",
				function()
					require("neo-tree.command").execute({ toggle = true })
				end,
			},
			{
				"<leader>tg",
				function()
					require("neo-tree.command").execute({ source = "git_status", toggle = true })
				end,
				desc = "Git Explorer",
			},
			{
				"<leader>tb",
				function()
					require("neo-tree.command").execute({ source = "buffers", toggle = true })
				end,
				desc = "Buffer Explorer",
			},
		},
		init = function()
			-- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
			-- because `cwd` is not set up properly.
			vim.api.nvim_create_autocmd("BufEnter", {
				group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
				desc = "Start Neo-tree with directory",
				once = true,
				callback = function()
					if package.loaded["neo-tree"] then
						return
					else
						local stats = vim.uv.fs_stat(vim.fn.argv(0))
						if stats and stats.type == "directory" then
							require("neo-tree")
						end
					end
				end,
			})
		end,
		---@module "neo-tree"
		---@type neotree.Config?
		opts = {},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "f-person/git-blame.nvim" },
		event = "VeryLazy",
		init = function()
			vim.g.lualine_laststatus = vim.o.laststatus
			if vim.fn.argc(-1) > 0 then
				-- set an empty statusline till lualine loads
				vim.o.statusline = " "
			else
				-- hide the statusline on the starter page
				vim.o.laststatus = 0
			end
		end,
		config = function()
			local git_blame = require("gitblame")
			vim.o.laststatus = vim.g.lualine_laststatus
			require("lualine").setup({
				options = {
					theme = "catppuccin",
					globalstatus = vim.o.laststatus == 3,
					disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
				},
				sections = {
					lualine_c = {
						{
							"filename",
							file_status = true,
							path = 4,
						},
					},
					lualine_x = {
						{ git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
						"filetype",
					},
					lualine_y = {
						"lsp_status",
					},
				},
				extensions = { "lazy", "mason", "neo-tree", "toggleterm", "trouble" },
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
					html = { "prettier" },
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
			vim.keymap.set("n", "<leader>ff", tel_built.find_files, opts)
			vim.keymap.set("n", "<leader>fF", tel_built.git_files, opts)
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
		config = function()
			require("leap").set_default_mappings()
		end,
	},
	{ "nvim-treesitter/nvim-treesitter-context", opts = {}, event = enterFileEvent },
	{
		"nmac427/guess-indent.nvim",
		event = enterFileEvent,
		config = function()
			require("guess-indent").setup({})
		end,
	},
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			options = {
				always_show_bufferline = false,
				diagnostics = "nvim_lsp",
				diagnostics_update_on_event = true,
			}
		},
		config = function()
			require("bufferline").setup()
		end,
	},
}
