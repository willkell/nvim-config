local enterFileEvent = { "BufReadPost", "BufNewFile", "BufWritePost" }

return {
	{ "numToStr/comment.nvim", opts = {}, event = "VeryLazy" },
	{
		"kylechui/nvim-surround",
		version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup()
		end,
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
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
		specs = {
			{
				"folke/snacks.nvim",
				opts = {
					picker = {
						win = {
							input = {
								keys = {
									["<a-s>"] = { "flash", mode = { "n", "i" } },
									["s"] = { "flash" },
								},
							},
						},
						actions = {
							flash = function(picker)
								require("flash").jump({
									pattern = "^",
									label = { after = { 0, 0 } },
									search = {
										mode = "search",
										exclude = {
											function(win)
												return vim.bo[vim.api.nvim_win_get_buf(win)].filetype
													~= "snacks_picker_list"
											end,
										},
									},
									action = function(match)
										local idx = picker.list:row2idx(match.pos[1])
										picker.list:_move(idx, true, true)
									end,
								})
							end,
						},
					},
				},
			},
		},
	},
	{ "nvim-treesitter/nvim-treesitter-context", opts = {}, event = "VeryLazy" },
	{
		"nmac427/guess-indent.nvim",
		event = "VeryLazy",
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
			},
		},
		config = function()
			require("bufferline").setup()
			-- Fix bufferline when restoring a session
			vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
				callback = function()
					vim.schedule(function()
						pcall(nvim_bufferline)
					end)
				end,
			})
		end,
	},
}
