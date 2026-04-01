return {
	{
		"kkoomen/vim-doge",
		build = ":call doge#install()",
		cmd = { "DogeGenerate" }, -- Chỉ load plugin khi gõ lệnh tạo doc
	},
	{
		"tpope/vim-fugitive",
		cmd = { "G", "Git", "Gdiffsplit" }, -- Lazy load cho lệnh Git
	},
	{
		"mbbill/undotree",
		keys = {
			{ "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle UndoTree" },
		},
		config = function()
			vim.opt.undofile = true
			vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
		end,
	},
	{
		"brenoprata10/nvim-highlight-colors",
		event = "BufReadPre", -- Tối ưu startup: Chỉ load khi đã đọc file
		config = function()
			require("nvim-highlight-colors").setup({
				render = "background", -- Render màu background nhìn cho "slay"
				enable_tailwind = true, -- Option ăn tiền nếu bro có dùng TailwindCSS
			})
		end,
	},
}
