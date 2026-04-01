-- KEYBINDS
vim.g.mapleader = " "

-- 📂 FILE & EXPLORER
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex, { desc = "Open Netrw (File Explorer)" })
vim.keymap.set("n", "<leader><leader>", function()
	-- Lấy định dạng file của cửa sổ hiện tại
	local ft = vim.bo.filetype

	-- Chỉ cho phép chạy lệnh source nếu nó thực sự là file config (Lua hoặc Vimscript)
	if ft == "lua" or ft == "vim" then
		vim.cmd("source %") -- % đại diện cho đường dẫn file hiện tại
		vim.notify("🚀 Đã nạp lại config: " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
	else
		-- Cảnh báo nhẹ nhàng nếu bro bấm nhầm lúc đang ở Neo-tree hoặc file PHP/JS
		vim.notify(
			"⚠️ Ảo thật đấy! Đang ở file '" .. ft .. "' mà bắt source cái gì?",
			vim.log.levels.WARN
		)
	end
end, { desc = "Source current file safely" })
vim.keymap.set("n", "<leader>rl", "<cmd>source ~/.config/nvim/init.lua<cr>", { desc = "Reload Neovim Config" })
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make current file executable" })

-- 🚀 MOVEMENT & EDITING (Thực chiến: Di chuyển mượt không lóa mắt)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected block down (like VSCode Alt+Down)" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected block up (like VSCode Alt+Up)" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll half page up (centered)" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })
vim.keymap.set("n", "<leader>nh", ":nohlsearch<CR>", { silent = true, desc = "Clear search highlights" })

-- 🛡️ CLIPBOARD & REGISTERS (Bí thuật giữ nguyên Clipboard)
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting register" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to blackhole register (keep clipboard)" })

-- ⚠️ BUG FIX: Thiếu dấu '>' ở config cũ của bro
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Escape insert mode properly (Ctrl+C act as Esc)" })

-- 💾 SAVE & QUIT
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set({ "n", "i", "v" }, "<C-q>", "<cmd>q<CR>", { desc = "Quit vim" })
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable annoying Ex mode" })

-- 📋 QUICKFIX & LOCATION LIST (Cực kỳ quan trọng khi tra Log/Diagnostics)
-- Lưu ý: Bro đang map trùng mục đích ở <C-j/k> và <leader>cn/cp. Nên chọn 1 style thôi!
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz", { desc = "Next Quickfix item" })
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz", { desc = "Prev Quickfix item" })
vim.keymap.set("n", "<leader>cl", ":cclose<CR>", { silent = true, desc = "Close Quickfix list" })
vim.keymap.set("n", "<leader>co", ":copen<CR>", { silent = true, desc = "Open Quickfix list" })
vim.keymap.set("n", "<leader>cn", ":cnext<CR>zz", { desc = "Next Quickfix item (Duplicate of C-j)" })
vim.keymap.set("n", "<leader>cp", ":cprev<CR>zz", { desc = "Prev Quickfix item (Duplicate of C-k)" })

vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next Location list item" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Prev Location list item" })

-- 🛠️ TOOLS & PLUGINS
vim.keymap.set("n", "<leader>dg", "<cmd>DogeGenerate<cr>", { desc = "Generate Docblocks (vim-doge)" })
vim.keymap.set("n", "<leader>cc", "<cmd>!php-cs-fixer fix % --using-cache=no<cr>", { desc = "Lint/Format PHP file" })
vim.keymap.set("n", "<leader>li", ":checkhealth vim.lsp<CR>", { desc = "LSP Info Healthcheck" })
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle UndoTree" })
vim.keymap.set("n", "<leader>bd", ":bd<CR>", { desc = "Close current buffer" })

-- 🌐 YANK (OSC52 cho SSH)
vim.keymap.set("n", "<leader>y", "<Plug>OSCYankOperator", { desc = "OSC Yank Operator (SSH Clipboard)" })
vim.keymap.set("v", "<leader>y", "<Plug>OSCYankVisual", { desc = "OSC Yank Visual (SSH Clipboard)" })

-- 🔍 SEARCH & REPLACE
-- Lưu ý: Lệnh :s/... chỉ replace trên *dòng hiện tại*. Nếu muốn toàn file, đổi thành :%s/...
vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]],
	{ desc = "Replace word under cursor (Current Line)" }
)

-- 🌳 NEO-TREE & WINDOWS
-- (Phần này bro đã ghi desc chuẩn rồi, anh giữ nguyên, chỉ format lại cho đẹp)
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree", silent = true })
vim.keymap.set("n", "<leader>o", ":Neotree focus<CR>", { desc = "Focus Neo-tree", silent = true })
vim.keymap.set(
	"n",
	"<leader>E",
	":Neotree toggle reveal<CR>",
	{ desc = "Reveal current file in Neo-tree", silent = true }
)
vim.keymap.set("n", "<leader>ge", ":Neotree float git_status<CR>", { desc = "Git status", silent = true })
vim.keymap.set("n", "<leader>be", ":Neotree toggle buffers<CR>", { desc = "Buffer list", silent = true })

-- Window Navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window", silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window", silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window", silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window", silent = true })
vim.keymap.set("n", "<Tab>", "<C-w>w", { desc = "Cycle through windows", silent = true })
