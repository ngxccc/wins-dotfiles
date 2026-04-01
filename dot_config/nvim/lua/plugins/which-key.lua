return {
	"folke/which-key.nvim",
	event = "VeryLazy", -- Tối ưu: Chỉ nạp khi Neovim đã khởi động xong, không làm chậm boot time
	opts = {
		-- Cấu hình giao diện (UI) đục lỗ, xịn xò
		preset = "modern",
		delay = function(ctx)
			return ctx.plugin and 0 or 300 -- Đợi 300ms (0.3s) trước khi văng menu ra
		end,
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)

		-- 🛡️ Đăng ký các "Group" (Nhóm) để menu nhìn ngầu và có tổ chức hơn
		-- Thay vì hiện bừa bãi, nó sẽ gom nhóm theo chữ cái đầu
		wk.add({
			{ "<leader>b", group = "Buffers" },
			{ "<leader>c", group = "Code/LSP" },
			{ "<leader>f", group = "Find/Telescope" },
			{ "<leader>g", group = "Git" },
		})
	end,
}
