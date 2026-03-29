return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	-- Tối ưu: Chỉ kích hoạt Treesitter khi em mở một file thật, không nạp lúc rảnh rỗi
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		-- 🛡️ BÍ THUẬT BẢO VỆ (Protected Call):
		-- Nếu file tải về bị lỗi mạng, status_ok sẽ là 'false', Neovim VẪN SỐNG!
		local status_ok, configs = pcall(require, "nvim-treesitter.configs")
		if not status_ok then
			vim.notify(
				"⚠️ [Treesitter] Đang tải ngầm hoặc bị lỗi! Hãy gõ :Lazy sync",
				vim.log.levels.WARN
			)
			return
		end

		-- Nếu sống sót qua ải trên, cấu hình bình thường
		configs.setup({
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
					},
				},
			},
			highlight = { enable = true },
			indent = { enable = true },
			autotag = { enable = true },
			ensure_installed = {
				"json",
				"python",
				"javascript",
				"query",
				"typescript",
				"tsx",
				"php",
				"yaml",
				"html",
				"css",
				"markdown",
				"markdown_inline",
				"bash",
				"lua",
				"vim",
				"vimdoc",
				"c",
				"dockerfile",
				"gitignore",
				"astro",
			},
			auto_install = false,
		})
	end,
}
