-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
    defaults = { lazy = true}
})

--util keymaps

local lspconfig = require 'lspconfig'

require("mason").setup()


local copyConfigFile = function()
    local configFile = nvim_config_home .. 'dapconfigs/' .. vim.bo.filetype .. '.dapconfig.lua'
    local dapFile, err = io.open(configFile, 'rb')
    if err then
        error(err)
    end
    local dapContent = dapFile:read '*a'
    dapFile.close()
    local writeFile, err2 = io.open(vim.fn.getcwd() .. '/.dapconfig.lua', 'w')
    if err2 then
        error(err2)
    end
    writeFile:write(dapContent)
    writeFile:close()
end
local copyOrEditConfigFile = function()
    local dapFile = io.open(vim.fn.getcwd() .. '/.dapconfig.lua', 'rb')
    if not dapFile then
        copyConfigFile()
    end
    vim.cmd [[execute "e .dapconfig.lua"]]
end

local on_attach = function()
    --Enable completion triggered by <c-x><c-o>
    vim.o.omnifunc = 'v:lua.vim.lsp.omnifunc'
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.keymap.set('n', 'gD', function()
        vim.lsp.buf.declaration()
    end, opts)
    vim.keymap.set('n', 'gd', function()
        vim.lsp.buf.definition()
    end, opts)
    vim.keymap.set('n', 'K', function()
        vim.lsp.buf.hover()
    end, opts)
    vim.keymap.set('n', 'gi', function()
        vim.lsp.buf.implementation()
    end, opts)
    vim.keymap.set('n', 'J', function()
        vim.lsp.buf.signature_help()
    end, opts)
    vim.keymap.set('n', '<leader>wa', function()
        vim.lsp.buf.add_workspace_folder()
    end, opts)
    vim.keymap.set('n', '<leader>wr', function()
        vim.lsp.buf.remove_workspace_folder()
    end, opts)
    vim.keymap.set('n', '<leader>D', function()
        vim.lsp.buf.type_definition()
    end, opts)
    vim.keymap.set('n', '<leader>rn', function()
        vim.lsp.buf.rename()
    end, opts)
    vim.keymap.set('n', '<leader>ca', function()
        vim.lsp.buf.code_action()
    end, opts)
    vim.keymap.set('n', 'gr', function()
        vim.lsp.buf.references()
    end, opts)
    vim.keymap.set('n', '<leader>e', function()
        vim.lsp.diagnostic.show_line_diagnostics()
    end, opts)
    vim.keymap.set('n', '[d', function()
        vim.lsp.diagnostic.goto_prev()
    end, opts)
    vim.keymap.set('n', ']d', function()
        vim.lsp.diagnostic.goto_next()
    end, opts)
    vim.keymap.set({'n', 'v'}, '<leader>=', function()
        require("conform").format()
    end, opts)
    vim.keymap.set('n', '<leader>dc', copyOrEditConfigFile, opts)
end

-- nvim-cmp supports additional completion capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()


-- Enable the following language servers
-- for _, lsp in ipairs(servers) do
--     lspconfig[lsp].setup {
--         on_attach = on_attach(),
--         capabilities = capabilities,
--     }
-- end

require 'lspconfig'.omnisharp.setup {
    cmd = { "dotnet", "/usr/lib/omnisharp-roslyn/OmniSharp.dll" },
    root_dir = lspconfig.util.root_pattern("*.csproj", "*.sln"),
    on_attach = on_attach(),
    capabilities = capabilities,
    -- Additional configuration can be added here
}
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
end

cmp.setup {
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        },
        ['<CR>'] = cmp.mapping.confirm { select = false }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = cmp.config.sources {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'buffer' },
        { name = 'orgmode' },
    },
}
cmp.setup.filetype("tex", {
    sources = cmp.config.sources({
        { name = 'vimtex' },
    })
})

-- insert brackets after completion
local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done { map_char = { tex = '' } })

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')
-- require('lspconfig').lua_ls.setup {
--     on_attach = on_attach(),
--     capabilities = capabilities,
--     settings = {
--         Lua = {
--             runtime = {
--                 -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--                 version = 'LuaJIT',
--                 -- Setup your lua path
--                 path = '/usr/bin/lua',
--             },
--             diagnostics = {
--                 -- Get the language server to recognize the `vim` global
--                 globals = { 'vim' },
--             },
--             workspace = {
--                 -- Make the server aware of Neovim runtime files
--                 checkThirdParty = false,
--                 library = vim.api.nvim_get_runtime_file('', true),
--                 preloadFileSize = 2000000,
--             },
--             telemetry = {
--                 enable = true,
--             },
--             completion = {
--                 callSnipped = "Replace"
--             }
--         },
--     },
-- }

-- LuaSnip
require('luasnip.loaders.from_vscode').load()
-- nvim comment
require('Comment').setup()

-- dap
local dap = require 'dap'
dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = '/home/wk/.vscode/extensions/ms-vscode.cpptools-1.8.4/debugAdapters/bin/OpenDebugAD7',
}
dap.adapters.python = {
    type = 'executable',
    command = '/usr/bin/python',
    args = { '-m', 'debugpy.adapter' },
}

--  dap keymaps
local dapui = require 'dapui'
local dapend = nil
local daprestart = nil
local dapstop = nil
local dapmaps = {
    {
        'n',
        '<C-c>',
        function()
            dap.continue()
        end,
        opts,
    },
    {
        'n',
        '<C-s>',
        function()
            dap.step_over()
        end,
        opts,
    },
    {
        'n',
        '<C-d>',
        function()
            dap.step_into()
        end,
        opts,
    },
    {
        'n',
        '<C-f>',
        function()
            dap.step_out()
        end,
        opts,
    },
    {
        'n',
        '<C-v>',
        function()
            dap.run_to_cursor()
        end,
        opts,
    },
    {
        'n',
        '<C-o>',
        function()
            dap.repl.toggle()
        end,
        opts,
    },
    {
        'n',
        '<C-x>',
        function()
            dapend()
        end,
        opts,
    },
    {
        'n',
        '<C-r>',
        function()
            daprestart()
        end,
        opts,
    },
    {
        'n',
        '<C-t>',
        function()
            dapstop()
        end,
        opts,
    },
}

function dapend()
    dap.terminate()
    dapui.close()
    for _, map in ipairs(dapmaps) do
        vim.keymap.del(map[1], map[2])
    end
    vim.cmd ':bd! */bin/sh'
end

function daprestart()
    dap.terminate()
    dap.run_last()
end

function dapstop()
    dap.terminate()
    for _, map in ipairs(dapmaps) do
        vim.keymap.del(map[1], map[2])
    end
end

vim.keymap.set('n', '<leader>dd', dap.continue, opts)
vim.keymap.set('n', '<leader>dl', dap.run_last, opts)
vim.keymap.set('n', '<leader>dbb', dap.toggle_breakpoint, opts)
vim.keymap.set('n', '<leader>dbc', function()
    dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, opts)
vim.keymap.set('n', '<leader>dbp', function()
    dap.set_breakpoint(nil, nil, vim.fn.input 'Log point message: ')
end, opts)

-- ui
dapui.setup()

dap.listeners.after.event_initialized['dapui_config'] = function()
    dapui.open()
    for _, map in ipairs(dapmaps) do
        vim.keymap.set(map[1], map[2], map[3], map[4])
    end
end
dap.listeners.after.event_terminated['dapui_config'] = function()
    dapui.close()
    for _, map in ipairs(dapmaps) do
        vim.keymap.del(map[1], map[2])
    end
    -- vim.cmd ':bd! */bin/sh'
end
-- toggleterm
vim.keymap.set('n', '<leader>tt', ':ToggleTerm<CR>', opts)
local Terminal = require('toggleterm.terminal').Terminal
local lazygit  = Terminal:new({ cmd = "lazygit", hidden = true, direction = 'float' })

function lazygit_toggle()
    lazygit:toggle()
end

vim.keymap.set("n", "<leader>gg", lazygit_toggle, opts)
-- keymaps to help terminal navigation
local function set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.api.nvim_create_autocmd("TermOpen", { pattern = 'term://*', callback = set_terminal_keymaps })


-- telescope
local telescope = require 'telescope'
local tel_built = require 'telescope.builtin'
telescope.setup()
-- telescope.load_extension 'fzf'
telescope.load_extension 'frecency'

-- telescope Mappings
vim.keymap.set('n', '<leader>ff', tel_built.find_files, opts)
vim.keymap.set('n', '<leader>fg', tel_built.live_grep, opts)
vim.keymap.set('n', '<leader>fb', tel_built.buffers, opts)
vim.keymap.set('n', '<leader>fh', tel_built.help_tags, opts)
vim.keymap.set('n', '<leader>fr', telescope.extensions.frecency.frecency, opts)
vim.keymap.set('n', '<leader>ft', tel_built.tags, opts)

-- treesitter
require('nvim-treesitter.configs').setup {
    highlight = { enable = true },
    incremental_selection = { enable = true },
    indent = { enable = true },
    endwise = { enable = true },
}
require('nvim-treesitter.parsers').get_parser_configs().asm = {
    install_info = {
        url = 'https://github.com/rush-rs/tree-sitter-asm.git',
        files = { 'src/parser.c' },
        branch = 'main',
    },
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.org = {
    install_info = {
        url = 'https://github.com/milisims/tree-sitter-org',
        revision = 'main',
        files = { 'src/parser.c', 'src/scanner.c' },
    },
    filetype = 'org',
}

--dap virtual text
require('nvim-dap-virtual-text').setup {
    highlight_changed_variables = true,
    highlight_new_as_changed = true,
}

-- autopairs
local npairs = require 'nvim-autopairs'
npairs.setup {
    check_ts = true,
}


local function lsp_progress()
    local messages = vim.lsp.util.get_progress_messages()
    if #messages == 0 then
        return
    end
    local status = {}
    for _, msg in pairs(messages) do
        table.insert(status, (msg.percentage or 0) .. "%% " .. (msg.title or ""))
    end
    local spinners = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    local ms = vim.loop.hrtime() / 1000000
    local frame = math.floor(ms / 120) % #spinners
    return table.concat(status, " | ") .. " " .. spinners[frame + 1]
end
local git_blame = require('gitblame')
-- This disables showing of the blame text next to the cursor
vim.g.gitblame_display_virtual_text = 0
-- lualine
require('lualine').setup {
    options = {
        theme = "zenburn",
    },
    sections = {
        lualine_c = {
            {
                'filename',
                file_status = true,
                path = 3,
            }
        },
        lualine_x = { { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available }, 'ctime', 'filetype' },
    },

}

require 'alpha'
--alpha-nvim
local alpha = require 'alpha'
local dashboard = require 'alpha.themes.dashboard'
dashboard.section.buttons.val = {
    dashboard.button('e', '   New file', ':enew <CR>'),
    dashboard.button('SPC l s', '   Open last session'),
    dashboard.button('SPC f f', '   Find file'),
    dashboard.button('SPC f r', '   Recent files'),
    dashboard.button('SPC e n', '   Edit Config'),
    dashboard.button('SPC f h', '   Help'),
    dashboard.button('q', '   Quit NVIM', ':qa<CR>'),
}
alpha.setup(dashboard.config)

-- file explorer
require('nvim-tree').setup()
vim.keymap.set('n', '<leader>tf', ':NvimTreeToggle<CR>', opts)

-- trouble
require('trouble').setup()
vim.keymap.set('n', '<leader>xx', ':Trouble<cr>', opts)
vim.keymap.set('n', '<leader>xw', ':Trouble workspace_diagnostics<cr>', opts)
vim.keymap.set('n', '<leader>xd', ':Trouble document_diagnostics<cr>', opts)
vim.keymap.set('n', '<leader>xl', ':Trouble loclist<cr>', opts)
vim.keymap.set('n', '<leader>xq', ':Trouble quickfix<cr>', opts)
vim.keymap.set('n', 'gR', ':Trouble lsp_references<cr>', opts)

-- null-ls
-- local null_ls = require 'null-ls'
-- local sources = {
--     null_ls.builtins.formatting.stylua.with {
--         extra_args = { '--config-path', vim.fn.expand '~/.config/formatters/stylua.toml', '--verify' },
--     },
--     null_ls.builtins.formatting.black,
--     null_ls.builtins.formatting.clang_format.with {
--         extra_args = { '--style', '{BasedOnStyle: LLVM, IndentWidth = 4}' },
--     },
--     null_ls.builtins.diagnostics.cppcheck.with {
--         extra_args = { '--std=c++17', '--language=c++' }
--     },
--     null_ls.builtins.diagnostics.luacheck.with {
--         extra_args = { '--globals', 'vim' },
--     },
--     null_ls.builtins.diagnostics.pylama,
--     null_ls.builtins.formatting.isort.with {
--         extra_args = { '--profile', 'black' },
--     },
--     null_ls.builtins.formatting.rustfmt,
-- }
-- null_ls.setup { sources = sources }
require 'lspconfig'.sqlls.setup {}

-- Treesitter configuration
require('nvim-treesitter.configs').setup {
    -- If TS highlights are not enabled at all, or disabled via `disable` prop,
    -- highlighting will fallback to default Vim syntax highlighting
    highlight = {
        enable = true,
        -- Required for spellcheck, some LaTex highlights and
        -- code block highlights that do not have ts grammar
        additional_vim_regex_highlighting = { 'org' },
    },
}

-- conform.nvim
require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "black" },
        javascript = { "prettier"},
    },
})


require("zenburn").setup()
