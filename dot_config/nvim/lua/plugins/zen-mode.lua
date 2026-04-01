return {
	"folke/zen-mode.nvim",
	cmd = "ZenMode",
	keys = {
		-- Bấm Space + z để Tắt/Bật chế độ Tu Tiên (Zen Mode)
		{ "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
	},
	opts = {
		window = {
			backdrop = 0.95, -- Làm tối các thành phần râu ria xung quanh (95%)
			width = 100, -- Ép chiều rộng dòng code gọn gàng ở giữa màn (chuẩn đọc code)
			options = {
				signcolumn = "no", -- Giấu luôn thanh báo lỗi
				number = false, -- Giấu số dòng
				relativenumber = false,
				cursorline = false,
			},
		},
		plugins = {
			-- Tích hợp: Tự động báo cho WezTerm biết đang bật Zen để nó tự làm mờ viền
			wezterm = { enabled = true, font = "+4" }, -- Tự động tăng size chữ lên 4px cho dễ nhìn
		},
	},
}
