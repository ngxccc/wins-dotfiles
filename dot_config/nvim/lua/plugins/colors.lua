return {
	{
		"folke/tokyonight.nvim",
		lazy = false, -- Đảm bảo theme load ngay từ đầu
		priority = 1000,
		opts = {
			transparent = true, -- 🚀 Tokyonight tự động lo vụ trong suốt từ A-Z!
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		},
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd.colorscheme("tokyonight")
		end,
	},
}
