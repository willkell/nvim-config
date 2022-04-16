-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.hidden = true
vim.o.relativenumber = true
vim.o.number = true
vim.o.errorbells = false
vim.o.smartindent = true
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = '~/.config/nvim/undodir'
vim.o.undofile = true
vim.o.incsearch = true
vim.o.scrolloff = 6
vim.o.colorcolumn = '80'
vim.o.signcolumn = 'yes'
vim.g.mapleader = ' '
vim.o.termguicolors = true
vim.cmd[[colorscheme vilight]]
vim.o.mouse = 'a'

local use = require('packer').use
require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim'
    use {'nvim-telescope/telescope.nvim',
        requires = {'nvim-lua/plenary.nvim'}}
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use 'kyazdani42/nvim-web-devicons'
    use 'neovim/nvim-lspconfig'
    use 'mfussenegger/nvim-dap'
    use { 'rcarriga/nvim-dap-ui', requires = {'mfussenegger/nvim-dap'} }
    use 'tpope/vim-surround'
    use 'tpope/vim-fugitive'
    use 'terrortylor/nvim-comment'
    use 'mbbill/undotree'
    use 'williamboman/nvim-lsp-installer'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'saadparwaiz1/cmp_luasnip'
    use 'L3MON4D3/LuaSnip'
    use 'rafamadriz/friendly-snippets'
    use 'klen/nvim-config-local'
    use 'akinsho/toggleterm.nvim'
    use 'ludovicchabant/vim-gutentags'
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use 'nvim-telescope/telescope-file-browser.nvim'
    use { 'tami5/sqlite.lua' }
    use {'nvim-telescope/telescope-frecency.nvim', requires = 'tami15/sqlite.lua'}
    use 'theHamsta/nvim-dap-virtual-text'
    use 'p00f/nvim-ts-rainbow'
    use 'RRethy/nvim-treesitter-endwise'
    use 'windwp/nvim-autopairs'
    use 'nvim-lualine/lualine.nvim'
    use 'github/copilot.vim'
end)

--util keymaps
local opts = {silent = true, remap = false}
vim.keymap.set({'n', 'v'}, 'j', 'gj', opts)
vim.keymap.set({'n', 'v'}, 'k', 'gk', opts)
vim.keymap.set({'n', 'v', 'i'}, '<Down>',function () vim.api.nvim_command('normal gj') end, opts)
vim.keymap.set({'n', 'v', 'i'}, '<Up>', function () vim.api.nvim_command('normal gk') end, opts)
vim.keymap.set('n', '<leader>cl', ':so ~/.config/nvim/init.lua<CR>', opts)
vim.keymap.set('n', ';;', '<escape>A;<escape>', opts)
vim.keymap.set('n', ',,', '<escape>A,<escape>', opts)
vim.keymap.set('n', '\\', '<escape>A \\<escape>', opts)
vim.keymap.set('n', '<leader>pi', ':PackerInstall<CR>', opts)
vim.keymap.set('n', '<leader>ps', ':PackerSync<CR>', opts)
vim.keymap.set('n', '<leader>wo', ':only<CR>', opts)
vim.keymap.set('n', '<leader>tb', ':w<CR>:TexlabBuild<CR>', opts)
vim.keymap.set('n', '<leader>en', ':e ~/.config/nvim/init.lua<CR>', opts)
vim.keymap.set('n', '<leader>s', function() vim.api.nvim_command('write') end, opts)
vim.keymap.set('n', '<leader>Q', ':wqa!<CR>', opts)
vim.keymap.set('n', '<leader>q', ':wq!<CR>', opts)



-- LSP Config
local lspconfig = require 'lspconfig'
local lsp_installer = require 'nvim-lsp-installer'

-- Include the servers you want to have installed by default below
local servers = {
    'bashls',
    'pyright',
    'clangd',
    'sumneko_lua',
    'texlab',
}

for _, name in pairs(servers) do
    local server_is_found, server = lsp_installer.get_server(name)
    if server_is_found then
        if not server:is_installed() then
            print('Installing ' .. name)
            server:install()
        end
    end
end
local copyConfigFile = function ()
    local configFile = '/home/wk/.config/nvim/' .. vim.bo.filetype .. '.dapconfig.lua'
    local dapFile, err = io.open(configFile, 'rb')
    if err then
        error(err)
    end
    local dapContent = dapFile:read('*a')
    dapFile.close()
    local writeFile, err2 = io.open(vim.lsp.buf.list_workspace_folders()[1] .. '/.dapconfig.lua', 'w')
    if err2 then
        error(err2)
    end
    writeFile:write(dapContent)
    writeFile:close()
end
local copyOrEditConfigFile = function ()
    local dapFile = io.open(vim.lsp.buf.list_workspace_folders()[1] .. '/.dapconfig.lua', 'rb')
    if not dapFile then
        copyConfigFile()
    end
    vim.cmd[[execute "e .dapconfig.lua"]]
end


local on_attach = function(_, bufnr)
    --Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {buffer = bufnr, unpack(opts)})
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer = bufnr, unpack(opts)})
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, {buffer = bufnr, unpack(opts)})
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {buffer = bufnr, unpack(opts)})
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, {buffer = bufnr, unpack(opts)})
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, {buffer = bufnr, unpack(opts)})
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, {buffer = bufnr, unpack(opts)})
    vim.keymap.set('n', '<leader>wl', vim.inspect(vim.lsp.buf.list_workspace_folders()), {buffer = bufnr, unpack(opts)})
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, {buffer = bufnr, unpack(opts)})
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {buffer = bufnr, unpack(opts)})
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {buffer = bufnr, unpack(opts)})
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, {buffer = bufnr, unpack(opts)})
    vim.keymap.set('n', '<leader>e', vim.lsp.diagnostic.show_line_diagnostics, {buffer = bufnr, unpack(opts)})
    vim.keymap.set('n', '[d', vim.lsp.diagnostic.goto_prev, {buffer = bufnr, unpack(opts)})
    vim.keymap.set('n', ']d', vim.lsp.diagnostic.goto_next, {buffer = bufnr, unpack(opts)})
    vim.keymap.set('n', '<leader>=', vim.lsp.buf.formatting, {buffer = bufnr, unpack(opts)})
    vim.keymap.set('n', '<leader>dc', copyOrEditConfigFile, {buffer = bufnr, unpack(opts)})
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Enable the following language servers
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach(_, 0),
        capabilities = capabilities,
    }
end

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require'cmp'
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

cmp.setup({
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
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
    }
})

-- insert brackets after completion
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))


local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')
require'lspconfig'.sumneko_lua.setup {
    on_attach = on_attach(_, 0),
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = '/usr/bin/lua'
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file('', true),
                preloadFileSize = 2000000
            },
            telemetry = {
                enable = true,
            },
        },
    },
}

-- LuaSnip
require('luasnip.loaders.from_vscode').load()
-- nvim comment
require('nvim_comment').setup()

-- dap
local dap = require('dap')
dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = '/home/wk/.vscode/extensions/ms-vscode.cpptools-1.8.4/debugAdapters/bin/OpenDebugAD7',
}

--  dap keymaps
local dapui = require 'dapui'
local dapend = nil
local daprestart = nil
local dapstop = nil
local dapmaps = {
{'n', '<C-c>', function() dap.continue() end, opts},
{'n', '<C-s>', function() dap.step_over() end, opts},
{'n', '<C-d>', function() dap.step_into() end, opts},
{'n', '<C-f>', function() dap.step_out() end, opts},
{'n', '<C-v>', function() dap.run_to_cursor() end, opts},
{'n', '<C-o>', function() dap.repl.toggle() end, opts},
{'n', '<C-x>', function() dapend() end, opts},
{'n', '<C-r>', function() daprestart() end, opts},
{'n', '<C-t>', function() dapstop() end, opts},
}

function dapend ()
    dap.terminate()
    dapui.close()
    for _, map in ipairs(dapmaps) do
        vim.keymap.del(map[1], map[2])
    end
    vim.cmd(':bd! */bin/sh')
end

function daprestart ()
    dap.terminate()
    dap.run_last()
end
function dapstop ()
    dap.terminate()
    for _, map in ipairs(dapmaps) do
        vim.keymap.del(map[1], map[2])
    end
end
vim.keymap.set('n', '<leader>dd', dap.continue, opts)
vim.keymap.set('n', '<leader>dl', dap.run_last, opts)
vim.keymap.set('n', '<leader>dbb', dap.toggle_breakpoint, opts)
vim.keymap.set('n', '<leader>dbc', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, opts)
vim.keymap.set('n', '<leader>dbp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, opts)



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
    vim.cmd(':bd! */bin/sh')
end
-- toggleterm
vim.keymap.set('n', '<leader>tt', ':ToggleTerm<CR>', opts)

-- local configs
require('config-local').setup {
    -- Default configuration (optional)
    config_files = { '.vimrc.lua', '.vimrc', '.dapconfig.lua' },  -- Config file patterns to load (lua supported)
    hashfile = vim.fn.stdpath('data') .. '/config-local', -- Where the plugin keeps files data
    autocommands_create = true,                 -- Create autocommands (VimEnter, DirectoryChanged)
    commands_create = true,                     -- Create commands (ConfigSource, ConfigEdit, ConfigTrust, ConfigIgnore)
    silent = true,                             -- Disable plugin messages (Config loaded/ignored)
}

-- telescope
local telescope = require('telescope')
local tel_built = require('telescope.builtin')
telescope.setup()
telescope.load_extension('fzf')
telescope.load_extension('frecency')

-- telescope Mappings
vim.keymap.set('n', '<leader>ff', tel_built.find_files, opts)
vim.keymap.set('n', '<leader>fg', tel_built.live_grep, opts)
vim.keymap.set('n', '<leader>fb', tel_built.buffers, opts)
vim.keymap.set('n', '<leader>fh', tel_built.help_tags, opts)
vim.keymap.set('n', '<leader>fb', telescope.extensions.file_browser.file_browser, opts)

-- treesitter
require'nvim-treesitter.configs'.setup {
    highlight = { enable = true },
    incremental_selection = { enable = true },
    indent = { enable = true },
    -- rainbow = { enable = true},
    endwise = { enable = true },
}

--dap virtual text
require('nvim-dap-virtual-text').setup {
    highlight_changed_variables = true,
    highlight_new_as_changed = true,
}

-- autopairs
local npairs = require'nvim-autopairs'
npairs.setup({
    check_ts = true
})


-- fugitive
vim.keymap.set('n', '<leader>gg', ':Git<CR>', opts)
vim.keymap.set('n', '<leader>ga', ':Git add *<CR>', opts)
vim.keymap.set('n', '<leader>gc', ':Git commit<CR>', opts)
vim.keymap.set('n', '<leader>gp', ':Git push<CR>', opts)

-- lualine
require'lualine'.setup()
