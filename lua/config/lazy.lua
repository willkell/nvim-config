-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

local copyConfigFile = function()
	local configFile = nvim_config_home .. "dapconfigs/" .. vim.bo.filetype .. ".dapconfig.lua"
	local dapFile, err = io.open(configFile, "rb")
	if err then
		error(err)
	end
	local dapContent = dapFile:read("*a")
	dapFile.close()
	local writeFile, err2 = io.open(vim.fn.getcwd() .. "/.dapconfig.lua", "w")
	if err2 then
		error(err2)
	end
	writeFile:write(dapContent)
	writeFile:close()
end
local copyOrEditConfigFile = function()
	local dapFile = io.open(vim.fn.getcwd() .. "/.dapconfig.lua", "rb")
	if not dapFile then
		copyConfigFile()
	end
	vim.cmd([[execute "e .dapconfig.lua"]])
end


-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- dap
local dap = require("dap")
dap.adapters.cppdbg = {
	id = "cppdbg",
	type = "executable",
	command = "/home/wk/.vscode/extensions/ms-vscode.cpptools-1.8.4/debugAdapters/bin/OpenDebugAD7",
}
dap.adapters.python = {
	type = "executable",
	command = "/usr/bin/python",
	args = { "-m", "debugpy.adapter" },
}

--  dap keymaps
local dapui = require("dapui")
local dapend = nil
local daprestart = nil
local dapstop = nil
local dapmaps = {
	{
		"n",
		"<C-c>",
		function()
			dap.continue()
		end,
		opts,
	},
	{
		"n",
		"<C-s>",
		function()
			dap.step_over()
		end,
		opts,
	},
	{
		"n",
		"<C-d>",
		function()
			dap.step_into()
		end,
		opts,
	},
	{
		"n",
		"<C-f>",
		function()
			dap.step_out()
		end,
		opts,
	},
	{
		"n",
		"<C-v>",
		function()
			dap.run_to_cursor()
		end,
		opts,
	},
	{
		"n",
		"<C-o>",
		function()
			dap.repl.toggle()
		end,
		opts,
	},
	{
		"n",
		"<C-x>",
		function()
			dapend()
		end,
		opts,
	},
	{
		"n",
		"<C-r>",
		function()
			daprestart()
		end,
		opts,
	},
	{
		"n",
		"<C-t>",
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
	vim.cmd(":bd! */bin/sh")
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

vim.keymap.set("n", "<leader>dd", dap.continue, opts)
vim.keymap.set("n", "<leader>dl", dap.run_last, opts)
vim.keymap.set("n", "<leader>dbb", dap.toggle_breakpoint, opts)
vim.keymap.set("n", "<leader>dbc", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, opts)
vim.keymap.set("n", "<leader>dbp", function()
	dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, opts)

-- ui
dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
	for _, map in ipairs(dapmaps) do
		vim.keymap.set(map[1], map[2], map[3], map[4])
	end
end
dap.listeners.after.event_terminated["dapui_config"] = function()
	dapui.close()
	for _, map in ipairs(dapmaps) do
		vim.keymap.del(map[1], map[2])
	end
	-- vim.cmd ':bd! */bin/sh'
end


--dap virtual text
require("nvim-dap-virtual-text").setup({
	highlight_changed_variables = true,
	highlight_new_as_changed = true,
})

vim.g.gitblame_display_virtual_text = 0
