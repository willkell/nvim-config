-- Install packer
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- figure out user
local handle = io.popen('whoami')
local output = handle:read('*a'):gsub('[\n\r]', '')

local nvim_config_home = ''
if vim.loop.os_uname().sysname == "Darwin" then
    nvim_config_home = '/Users/' .. output .. '/.config/nvim/'
elseif vim.loop.os_uname().sysname == "Windows_NT" then
    nvim_config_home = 'C:\\Users\\' .. string.sub(output, 9, -1) .. '\\AppData\\Local\\nvim\\'
else
    nvim_config_home = '/home/' .. output .. '/.config/nvim/'
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
vim.o.undodir = nvim_config_home .. 'undodir'
vim.o.undofile = true
vim.o.incsearch = true
vim.o.scrolloff = 6
vim.o.colorcolumn = '80'
vim.o.signcolumn = 'yes'
vim.g.mapleader = ' '
vim.o.termguicolors = true
vim.o.mouse = 'a'
vim.o.laststatus = 3
vim.o.mousemodel = extend

local use = require('packer').use
require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use "williamboman/mason-lspconfig.nvim"
    use "williamboman/mason.nvim"
    use 'nvim-lua/plenary.nvim'
    use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'kyazdani42/nvim-web-devicons'
    use 'neovim/nvim-lspconfig'
    use 'mfussenegger/nvim-dap'
    use { 'rcarriga/nvim-dap-ui', requires = { 'mfussenegger/nvim-dap' } }
    use 'tpope/vim-surround'
    use 'numToStr/comment.nvim'
    use 'mbbill/undotree'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-path'
  use { "nvim-neotest/nvim-nio" }
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'saadparwaiz1/cmp_luasnip'
    use 'L3MON4D3/LuaSnip'
    use 'rafamadriz/friendly-snippets'
    use 'klen/nvim-config-local'
    use { 'akinsho/toggleterm.nvim', tag = 'v1.*' }
    use 'ludovicchabant/vim-gutentags'
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
    use { 'tami5/sqlite.lua' }
    use { 'nvim-telescope/telescope-frecency.nvim', requires = 'tami15/sqlite.lua' }
    use 'theHamsta/nvim-dap-virtual-text'
    use 'hiphish/rainbow-delimiters.nvim'
    use 'RRethy/nvim-treesitter-endwise'
    use 'windwp/nvim-autopairs'
    use 'nvim-lualine/lualine.nvim'
    use 'rrethy/nvim-base16'
    use 'neomake/neomake'
    use 'goolord/alpha-nvim'
    use 'shatur/neovim-session-manager'
    use 'kyazdani42/nvim-tree.lua'
    use 'nvim-lua/popup.nvim'
    use 'tjdevries/nlua.nvim'
    use 'euclidianAce/BetterLua.vim'
    use 'ThePrimeagen/refactoring.nvim'
    use { 'folke/trouble.nvim', requires = 'kyazdani42/nvim-web-devicons' }
    use 'lukas-reineke/indent-blankline.nvim'
    use 'jose-elias-alvarez/null-ls.nvim'
    use 'tpope/vim-repeat'
    use 'mfussenegger/nvim-jdtls'
    use 'JuliaEditorSupport/julia-vim'
    use 'folke/neodev.nvim'
    use { 'rush-rs/tree-sitter-asm' }
    use 'nvim-orgmode/orgmode'
    use 'lervag/vimtex'
    use{  'nvim-neorg/neorg', run = ':Neorg sync-parsers' }
    if packer_bootstrap then
        require('packer').sync()
    end
end)

-- makes things load faster
vim.loader.enable()
--util keymaps
local opts = { silent = true, remap = false }
vim.keymap.set({ 'n', 'v' }, 'j', 'gj', opts)
vim.keymap.set({ 'n', 'v' }, 'k', 'gk', opts)
vim.keymap.set({ 'n', 'v', 'i' }, '<Down>', function()
    vim.api.nvim_command 'normal gj'
end, opts)
vim.keymap.set({ 'n', 'v', 'i' }, '<Up>', function()
    vim.api.nvim_command 'normal gk'
end, opts)
vim.keymap.set('n', '<leader>cl', ':so ' .. nvim_config_home .. 'init.lua<CR>', opts)
vim.keymap.set('n', ';;', '<escape>A;<escape>', opts)
vim.keymap.set('n', ',,', '<escape>A,<escape>', opts)
vim.keymap.set('n', '\\', '<escape>A \\<escape>', opts)
vim.keymap.set('n', '<leader>pi', ':PackerInstall<CR>', opts)
vim.keymap.set('n', '<leader>ps', ':PackerSync<CR>', opts)
vim.keymap.set('n', '<leader>wo', ':only<CR>', opts)
vim.keymap.set('n', '<leader>tb', ':w<CR>:TexlabBuild<CR>', opts)
vim.keymap.set('n', '<leader>en', ':e ' .. nvim_config_home .. 'init.lua<CR>', opts)
vim.keymap.set('n', '<leader>s', function()
    vim.api.nvim_command 'write'
end, opts)
vim.keymap.set('n', '<leader>Q', ':wqa!<CR>', opts)
vim.keymap.set('n', '<leader>q', ':wq!<CR>', opts)
-- move windows
vim.keymap.set('n', '<leader>wh', '<c-w>h', opts)
vim.keymap.set('n', '<leader>wj', '<c-w>j', opts)
vim.keymap.set('n', '<leader>wk', '<c-w>k', opts)
vim.keymap.set('n', '<leader>wl', '<c-w>l', opts)


-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup({
    -- add any options here, or leave empty to use the default settings
})
-- LSP Config
local lspconfig = require 'lspconfig'
-- Include the servers you want to have installed by default below
local servers = {
    'bashls',
    'pyright',
    'clangd',
    'lua_ls',
    'texlab',
    'rust_analyzer',
    'sqlls',
    'julials',
    'tsserver',
    'asm_lsp',
}

require("mason").setup()
require("mason-lspconfig").setup()


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
    vim.keymap.set('n', '<leader>wl', function()
        vim.inspect(vim.lsp.buf.list_workspace_folders())()
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
    vim.keymap.set('n', '<leader>=', function()
        vim.lsp.buf.format { async = true }
    end, opts)
    vim.keymap.set('n', '<leader>dc', copyOrEditConfigFile, opts)
end

-- nvim-cmp supports additional completion capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Enable the following language servers
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach(),
        capabilities = capabilities,
    }
end

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
require('lspconfig').lua_ls.setup {
    on_attach = on_attach(),
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = '/usr/bin/lua',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file('', true),
                preloadFileSize = 2000000,
            },
            telemetry = {
                enable = true,
            },
            completion = {
                callSnipped = "Replace"
            }
        },
    },
}

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


-- local configs
require('config-local').setup {
    -- Default configuration (optional)
    config_files = { '.vimrc.lua', '.vimrc', '.dapconfig.lua' }, -- Config file patterns to load (lua supported)
    hashfile = vim.fn.stdpath 'data' .. '/config-local',         -- Where the plugin keeps files data
    autocommands_create = true,                                  -- Create autocommands (VimEnter, DirectoryChanged)
    commands_create = true,                                      -- Create commands (ConfigSource, ConfigEdit, ConfigTrust, ConfigIgnore)
    silent = true,                                               -- Disable plugin messages (Config loaded/ignored)
}

-- telescope
local telescope = require 'telescope'
local tel_built = require 'telescope.builtin'
telescope.setup()
telescope.load_extension 'fzf'
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


-- lualine
require('lualine').setup {
    sections = {
        lualine_c = {
            {
                'filename',
                file_status = true,
                path = 3,
            }
        },
        lualine_x = { 'ctime', 'filetype' },
    },

}

-- if .colorscheme doesn't exist create it
if vim.fn.filereadable(nvim_config_home .. '.colorscheme') == 0 then
    local f = io.open(nvim_config_home .. '.colorscheme', "w")
    f:write("base16-zenburn")
    f:close()
end
-- this is our single source of truth created above
local base16_theme_fname = vim.fn.expand(nvim_config_home .. '.colorscheme')
-- this function is the only way we should be setting our colorscheme
local function set_colorscheme(name)
    -- set Neovim's colorscheme
    vim.cmd('colorscheme ' .. name)
    -- if we are using kitty, set kitty colors too
    if os.getenv("TERM") == 'xterm-kitty' then
        -- write our colorscheme back to our single source of truth
        vim.fn.writefile({ name }, base16_theme_fname)
        -- execute `kitty @ set-colors -c <color>` to change terminal window's
        -- colors and newly created terminal windows colors
        os.execute('ln -sf ~/.config/kitty/colors/colors/' .. name .. '.conf ~/.config/kitty/theme.conf')
    end
end

set_colorscheme(vim.fn.readfile(base16_theme_fname)[1])
local telescope_actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local telescope_action_set = require 'telescope.actions.set'

vim.keymap.set('n', '<leader>fc', function()
    -- get our base16 colorschemes
    local colors = vim.fn.getcompletion('base16', 'color')
    -- we're trying to mimic VSCode so we'll use dropdown theme
    local theme = require('telescope.themes').get_dropdown()
    -- create our picker
    require('telescope.pickers').new(theme, {
        prompt_title = 'Change Colorscheme',
        finder = require('telescope.finders').new_table {
            results = colors,
        },
        sorter = require('telescope.config').values.generic_sorter(theme),
        attach_mappings = function(bufnr)
            -- change the colors upon selection
            telescope_actions.select_default:replace(function()
                set_colorscheme(action_state.get_selected_entry().value)
                telescope_actions.close(bufnr)
            end)
            telescope_action_set.shift_selection:enhance {
                -- change the colors upon scrolling
                post = function()
                    set_colorscheme(action_state.get_selected_entry().value)
                end,
            }
            return true
        end,
    }):find()
end, opts)

-- neomake
vim.cmd "call neomake#configure#automake('w')"
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
--session manager
require('session_manager').setup {
    autoload_mode = require('session_manager.config').AutoloadMode.Disabled,
}
vim.keymap.set('n', '<leader>ls', ':SessionManager load_last_session<CR>', opts)

-- file explorer
require('nvim-tree').setup()
vim.keymap.set('n', '<leader>tf', ':NvimTreeToggle<CR>', opts)

-- refactoring
require('refactoring').setup {}
opts = { noremap = true, silent = true, expr = false }
vim.keymap.set('v', '<leader>re', [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], opts)
vim.keymap.set(
    'v',
    '<leader>rf',
    [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
    opts
)
vim.keymap.set('v', '<leader>rv', [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]], opts)
vim.keymap.set('v', '<leader>ri', [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], opts)
vim.keymap.set('n', '<leader>rb', [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]], opts)
vim.keymap.set('n', '<leader>rbf', [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]], opts)

vim.keymap.set('n', '<leader>ri', [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], opts)

-- trouble
require('trouble').setup()
vim.keymap.set('n', '<leader>xx', ':Trouble<cr>', opts)
vim.keymap.set('n', '<leader>xw', ':Trouble workspace_diagnostics<cr>', opts)
vim.keymap.set('n', '<leader>xd', ':Trouble document_diagnostics<cr>', opts)
vim.keymap.set('n', '<leader>xl', ':Trouble loclist<cr>', opts)
vim.keymap.set('n', '<leader>xq', ':Trouble quickfix<cr>', opts)
vim.keymap.set('n', 'gR', ':Trouble lsp_references<cr>', opts)

-- null-ls
local null_ls = require 'null-ls'
local sources = {
    null_ls.builtins.formatting.stylua.with {
        extra_args = { '--config-path', vim.fn.expand '~/.config/formatters/stylua.toml', '--verify' },
    },
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.clang_format.with {
        extra_args = { '--style', '{BasedOnStyle: LLVM, IndentWidth = 4}' },
    },
    null_ls.builtins.diagnostics.cppcheck.with {
        extra_args = { '--std=c++17', '--language=c++' }
    },
    null_ls.builtins.diagnostics.luacheck.with {
        extra_args = { '--globals', 'vim' },
    },
    null_ls.builtins.diagnostics.pylama,
    null_ls.builtins.formatting.isort.with {
        extra_args = { '--profile', 'black' },
    },
    null_ls.builtins.formatting.rustfmt,
}
null_ls.setup { sources = sources }
require 'lspconfig'.sqlls.setup {}
-- Load custom treesitter grammar for org filetype
require('orgmode').setup_ts_grammar()

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

require('orgmode').setup({
    notifications = { enabled = true },
    org_agenda_files = '~/notes/*'
})

require('neorg').setup {
    load = {
        ["core.defaults"] = {}
    }
}
