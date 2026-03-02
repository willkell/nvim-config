local enterFileEvent = { "BufReadPost", "BufNewFile", "BufWritePost" }

-- load treesitter automatically
vim.api.nvim_create_autocmd({ "Filetype" }, {
	callback = function(event)
		-- make sure nvim-treesitter is loaded
		local ok, nvim_treesitter = pcall(require, "nvim-treesitter")

		-- no nvim-treesitter, maybe fresh install
		if not ok then
			return
		end

		local parsers = require("nvim-treesitter.parsers")

		if not parsers[event.match] or not nvim_treesitter.install then
			return
		end

		local ft = vim.bo[event.buf].ft
		local lang = vim.treesitter.language.get_lang(ft)
		nvim_treesitter.install({ lang }):await(function(err)
			if err then
				vim.notify("Treesitter install error for ft: " .. ft .. " err: " .. err)
				return
			end

			pcall(vim.treesitter.start, event.buf)
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		end)
	end,
})

return {
	{
		"neovim/nvim-lspconfig",
		event = enterFileEvent,
		config = function()
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = {
								vim.env.VIMRUNTIME,
								vim.fn.stdpath("config"),
								vim.fn.stdpath("data") .. "/lazy",
							},
							checkThirdParty = false,
						},
					},
				},
			})
			-- LspAttach is where you enable features that only work
			-- if there is a language server active in the file
			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local opts = { buffer = event.buf }
					vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
					vim.keymap.set("n", "gq", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
					vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
					vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
					vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
				end,
			})
		end,
	},
	{ "mason-org/mason.nvim", opts = {}, event = "VeryLazy" },
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {},
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		event = "VeryLazy",
	},
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		event = "InsertEnter",
		version = "1.*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = { preset = "default" },

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = { documentation = { auto_show = false } },

			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
				per_filetype = {
					codecompanion = { "codecompanion" },
				},
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
			signature = { enabled = true },
		},
		opts_extend = { "sources.default" },
	},
	{ "rafamadriz/friendly-snippets", event = "InsertEnter" },
	{ "mfussenegger/nvim-dap", event = "VeryLazy" },
	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }, event = "VeryLazy" },
	{ "theHamsta/nvim-dap-virtual-text", event = "VeryLazy" },
	{ "folke/lazydev.nvim", ft = "lua" },
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		specs = {
			"folke/snacks.nvim",
			opts = function(_, opts)
				return vim.tbl_deep_extend("force", opts or {}, {
					picker = {
						actions = require("trouble.sources.snacks").actions,
						win = {
							input = {
								keys = {
									["<c-t>"] = {
										"trouble_open",
										mode = { "n", "i" },
									},
								},
							},
						},
					},
				})
			end,
		},
		keys = {
			{

				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
			{
				"[q",
				function()
					if require("trouble").is_open() then
						require("trouble").prev({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cprev)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = "Previous Trouble/Quickfix Item",
			},
			{
				"]q",
				function()
					if require("trouble").is_open() then
						require("trouble").next({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cnext)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = "Next Trouble/Quickfix Item",
			},
		},
	},
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		event = "VeryLazy",
		dependencies = {
			{ "folke/ts-comments.nvim", opts = {} },
		},

		branch = "main",
		build = function()
			-- update parsers, if TSUpdate exists
			if vim.fn.exists(":TSUpdate") == 2 then
				vim.cmd("TSUpdate")
			end
		end,

		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
		---@module 'nvim-treesitter'
		---@type TSConfig
		---@diagnostic disable-next-line: missing-fields

		config = function(_, _)
			local ensure_installed = {
				"bash",
				"c",
				"css",
				"diff",
				"gitcommit",
				"html",
				"javascript",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
				"python",
			}

			-- make sure nvim-treesitter can load
			local ok, nvim_treesitter = pcall(require, "nvim-treesitter")

			-- no nvim-treesitter, maybe fresh install
			if not ok then
				return
			end

			nvim_treesitter.install(ensure_installed)
		end,
	},

	---@module 'lazy'
	---@type LazySpec
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = "VeryLazy",

		branch = "main",

		keys = {
			{
				"[f",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
				end,
				desc = "prev function",
				mode = { "n", "x", "o" },
			},
			{
				"]f",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
				end,
				desc = "next function",
				mode = { "n", "x", "o" },
			},
			{
				"[F",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
				end,
				desc = "prev function end",
				mode = { "n", "x", "o" },
			},
			{
				"]F",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
				end,
				desc = "next function end",
				mode = { "n", "x", "o" },
			},
			{
				"[a",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.outer", "textobjects")
				end,
				desc = "prev argument",
				mode = { "n", "x", "o" },
			},
			{
				"]a",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.outer", "textobjects")
				end,
				desc = "next argument",
				mode = { "n", "x", "o" },
			},
			{
				"[A",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_end("@parameter.outer", "textobjects")
				end,
				desc = "prev argument end",
				mode = { "n", "x", "o" },
			},
			{
				"]A",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_end("@parameter.outer", "textobjects")
				end,
				desc = "next argument end",
				mode = { "n", "x", "o" },
			},
			{
				"[s",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_start("@block.outer", "textobjects")
				end,
				desc = "prev block",
				mode = { "n", "x", "o" },
			},
			{
				"]s",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start("@block.outer", "textobjects")
				end,
				desc = "next block",
				mode = { "n", "x", "o" },
			},
			{
				"[S",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_end("@block.outer", "textobjects")
				end,
				desc = "prev block",
				mode = { "n", "x", "o" },
			},
			{
				"]S",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_end("@block.outer", "textobjects")
				end,
				desc = "next block",
				mode = { "n", "x", "o" },
			},
			{
				"gan",
				function()
					require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
				end,
				desc = "swap next argument",
			},
			{
				"gap",
				function()
					require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
				end,
				desc = "swap prev argument",
			},
		},

		opts = {
			move = {
				enable = true,
				set_jumps = true,
			},
			swap = {
				enable = true,
			},
		},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{ "HiPhish/rainbow-delimiters.nvim", event = enterFileEvent },
	{
		"windwp/nvim-ts-autotag",
		event = "VeryLazy",
		opts = {},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = enterFileEvent,
		dependencies = { "HiPhish/rainbow-delimiters.nvim" },
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {},
	},
	-- Better text-objects
	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		opts = function()
			local ai = require("mini.ai")
			return {
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({ -- code block
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}),
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
					c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
					t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
					d = { "%f[%d]%d+" }, -- digits
					e = { -- Word with case
						{
							"%u[%l%d]+%f[^%l%d]",
							"%f[%S][%l%d]+%f[^%l%d]",
							"%f[%P][%l%d]+%f[^%l%d]",
							"^[%l%d]+%f[^%l%d]",
						},
						"^().*()$",
					},
					u = ai.gen_spec.function_call(), -- u for "Usage"
					U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
				},
			}
		end,
		config = function(_, opts)
			require("mini.ai").setup(opts)
		end,
	},
	{ "Glench/Vim-Jinja2-Syntax" },
	{
		"olimorris/codecompanion.nvim",
		opts = {
			interactions = {
				chat = {
					adapter = "claude_code",
				},
				background = {
					chat = {
						adapter = "claude_code",
					},
				},
			},
			display = {
				diff = {
					enabled = true,
					provider = "inline",
					provider_opts = {
						inline = {
							layout = "buffer",
						},
					},
				},
				chat = {
					window = {
						layout = "vertical",
						position = "right",
						width = 0.3,
					},
				},
			},
			adapters = {
				acp = {
					gemini_cli = function()
						return require("codecompanion.adapters").extend("gemini_cli", {
							cmd = "yolo",
							defaults = {
								auth_method = "oauth-personal", -- "oauth-personal"|"gemini-api-key"|"vertex-ai"
							},
						})
					end,
					claude_code = function()
						return require("codecompanion.adapters").extend("claude_code", {
							env = {
								CLAUDE_CODE_OAUTH_TOKEN = "cmd:op read op://Private/Claude/token",
							},
						})
					end,
				},
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-mini/mini.diff",
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{
				"<leader>cca",
				"<CMD>CodeCompanionActions<CR>",
				mode = { "n", "v" },
				noremap = true,
				silent = true,
				desc = "CodeCompanion actions",
			},
			{
				"<leader>cci",
				"<CMD>CodeCompanion<CR>",
				mode = { "n", "v" },
				noremap = true,
				silent = true,
				desc = "CodeCompanion inline",
			},
			{
				"<leader>ccc",
				"<CMD>CodeCompanionChat Toggle<CR>",
				mode = { "n", "v" },
				noremap = true,
				silent = true,
				desc = "CodeCompanion chat (toggle)",
			},
			{
				"<leader>ccp",
				"<CMD>CodeCompanionChat Add<CR>",
				mode = { "v" },
				noremap = true,
				silent = true,
				desc = "CodeCompanion chat add code",
			},
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
		ft = { "markdown", "codecompanion" },
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},
	{
		"nvim-mini/mini.diff",
		version = false,
		opts = {},
	},
	{
		"zbirenbaum/copilot.lua",
		event = "VeryLazy",
		config = function()
			require("copilot").setup({})
		end,
	},
	{
		"chomosuke/typst-preview.nvim",
		ft = "typst",
		version = "1.*",
		opts = {},
	},
}
