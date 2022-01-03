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
vim.o.exrc = true
vim.o.errorbells = false
vim.o.smartindent = true
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = '~/.config/nvim/undodir/'
vim.o.undofile = true
vim.o.incsearch = true
vim.o.scrolloff = 6
vim.o.colorcolumn = '80'
vim.o.signcolumn = 'yes'
vim.g.mapleader = " "
vim.o.termguicolors = true
vim.cmd[[colorscheme zenburn]]
vim.o.mouse = 'a'

local use = require('packer').use
require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim'
    use {'nvim-telescope/telescope.nvim',
	requires = { {'nvim-lua/plenary.nvim'}}}
    use 'nvim-treesitter/nvim-treesitter'
    use 'kyazdani42/nvim-web-devicons'
    use 'neovim/nvim-lspconfig'
    use 'mfussenegger/nvim-dap'
    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
    use 'tanvirtin/monokai.nvim'
    use 'tpope/vim-surround'
    use 'tpope/vim-fugitive'
    use 'terrortylor/nvim-comment'
    use 'mbbill/undotree'
    use 'vim-airline/vim-airline'
    use 'preservim/nerdtree'
    use 'vim-airline/vim-airline-themes'
    use 'williamboman/nvim-lsp-installer'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'saadparwaiz1/cmp_luasnip'
    use 'L3MON4D3/LuaSnip'
    use "Pocco81/DAPInstall.nvim"
end)

-- keymaps
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<leader>ff', [[<cmd>lua require('telescope.builtin').find_files()<CR>]], opts)
vim.api.nvim_set_keymap('n', '<leader>fg', [[<cmd>lua require('telescope.builtin').live_grep()<cr>]], opts)
vim.api.nvim_set_keymap('n', '<leader>fb', [[<cmd>lua require('telescope.builtin').buffers()<cr>]], opts)
vim.api.nvim_set_keymap('n', '<leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<cr>]], opts)


-- LSP Config
local lspconfig = require 'lspconfig'
local lsp_installer = require "nvim-lsp-installer"

-- Include the servers you want to have installed by default below
local servers = {
  "bashls",
  "pyright",
  "clangd",
  "sumneko_lua",
}

for _, name in pairs(servers) do
  local server_is_found, server = lsp_installer.get_server(name)
  if server_is_found then
    if not server:is_installed() then
      print("Installing " .. name)
      server:install()
    end
  end
end

config = function()
    local lsp_installer = require("nvim-lsp-installer")

    lsp_installer.on_server_ready(function(server)
      local on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        --Enable completion triggered by <c-x><c-o>
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        local opts = { noremap=true, silent=true }

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
        buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
        buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
        buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
        buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        buf_set_keymap('n', '<space>=', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
      end

      server:setup({
        on_attach = on_attach()
      })

      vim.cmd [[ do User LspAttachBuffers ]]
    end)
end
-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Enable the following language servers
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
local sumneko_binary_path = vim.fn.exepath('lua-language-server')
local sumneko_root_path = vim.fn.fnamemodify(sumneko_binary_path, ':h:h:h')

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
require'lspconfig'.sumneko_lua.setup {
    cmd = {sumneko_binary_path, "-E", sumneko_root_path .. "/main.lua"};
    settings = {
        Lua = {
        runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
            -- Setup your lua path
            path = runtime_path,
        },
        diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {'vim'},
        },
        workspace = {
            -- Make the server aware of Neovim runtime files
            checkThirdParty = false,
            library = "${3rd}/love2d/library",
            preloadFileSize = 2000
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
            enable = true,
        },
        },
    },
}

-- nvim comment
require('nvim_comment').setup()

-- dap
require('dap')
vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
-- local dap = require('dap')
-- dap.adapters.lldb = {
--   type = 'executable',
--   command = '/usr/bin/lldb-vscode-10', -- adjust as needed
--   name = "lldb"
-- }
--
-- -- Configurations
--
-- local dap = require('dap')
-- dap.configurations.cpp = {
--   {
--     name = "Launch",
--     type = "lldb",
--     request = "launch",
--     program = function()
--       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--     end,
--     cwd = '${workspaceFolder}',
--     stopOnEntry = false,
--     args = {},
--
--     -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
--     --
--     --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
--     --
--     -- Otherwise you might get the following error:
--     --
--     --    Error on launch: Failed to attach to the target process
--     --
--     -- But you should be aware of the implications:
--     -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
--     runInTerminal = false,
--   },
-- }
-- ui
require("dapui").setup()
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- installer
local dap_install = require("dap-install")
dap_install.config("ccppr_vsc", {})
dap_install.setup({
	installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
})
