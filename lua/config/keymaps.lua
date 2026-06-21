local opts = { silent = true, remap = false }

local map = vim.keymap.set
-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map({ "n", "i" }, "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map({ "n", "i" }, "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map({ "n", "i" }, "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map({ "n", "i" }, "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Resize window using <ctrl> arrow keys.
-- The shared border follows the arrow direction regardless of where the
-- current window sits relative to its neighbors.
local function resize_horizontal(dir)
	-- true when there is a window to the right of the current one
	local has_right = vim.fn.winnr("l") ~= vim.fn.winnr()
	local grow = (dir == "right") == has_right
	vim.cmd("vertical resize " .. (grow and "+2" or "-2"))
end

local function resize_vertical(dir)
	-- true when there is a window below the current one
	local has_below = vim.fn.winnr("j") ~= vim.fn.winnr()
	local grow = (dir == "down") == has_below
	vim.cmd("resize " .. (grow and "+2" or "-2"))
end

map("n", "<C-Up>", function() resize_vertical("up") end, { desc = "Resize Window Up" })
map("n", "<C-Down>", function() resize_vertical("down") end, { desc = "Resize Window Down" })
map("n", "<C-Left>", function() resize_horizontal("left") end, { desc = "Resize Window Left" })
map("n", "<C-Right>", function() resize_horizontal("right") end, { desc = "Resize Window Right" })
map("n", "<leader>wo", ":only<CR>", opts)

-- Move Lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Clear search and stop snippet on escape
map({ "i", "n", "s" }, "<esc>", function()
	vim.cmd("noh")
	return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- windows
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- save
map("n", "<leader>.", function()
	vim.cmd.update() -- only saves when the file is changed
end, opts)

-- easy quit
-- Snacks' terminal closes its own window on ExitPre, which aborts :qa when run
-- from inside the terminal. Step out to a normal window first, then quit all.
map("n", "<leader>qq", function()
	if vim.bo.buftype == "terminal" then
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			if vim.bo[vim.api.nvim_win_get_buf(win)].buftype == "" then
				vim.api.nvim_set_current_win(win)
				break
			end
		end
	end
	vim.cmd("qa")
end, opts)
map("n", "<leader>ww", "<cmd>wa<cr>", opts)

-- Yank into system clipboard
map({ "n", "v" }, "<leader>y", '"+y') -- yank motion
map({ "n", "v" }, "<leader>Y", '"+Y') -- yank line

-- Delete into system clipboard
map({ "n", "v" }, "<leader>d", '"+d') -- delete motion
map({ "n", "v" }, "<leader>D", '"+D') -- delete line

-- Paste from system clipboard
map("n", "<leader>p", '"+p') -- paste after cursor
map("n", "<leader>P", '"+P') -- paste before cursor

-- diagnostic
local diagnostic_goto = function(next, severity)
	return function()
		vim.diagnostic.jump({
			count = (next and 1 or -1) * vim.v.count1,
			severity = severity and vim.diagnostic.severity[severity] or nil,
			float = true,
		})
	end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
