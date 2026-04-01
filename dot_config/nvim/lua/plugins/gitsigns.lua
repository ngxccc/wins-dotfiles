return {
	"lewis6991/gitsigns.nvim",
	-- Load lazy: Chỉ kích hoạt plugin khi mở một file đã có nội dung hoặc tạo file mới
	event = { "BufReadPre", "BufNewFile" },
	opts = function()
		return {
			-- Bộ icon Nerd Font "quốc dân", gọn gàng và tinh tế
			signs = {
				add = { text = "▎" }, -- Khối dọc dày (Code mới)
				change = { text = "▎" }, -- Khối dọc dày (Code sửa)
				delete = { text = "" }, -- Mũi tên tam giác chỉ sang phải (Code bị xóa)
				topdelete = { text = "" }, -- Mũi tên tam giác (Xóa ở đầu file)
				changedelete = { text = "▍" }, -- Khối dọc lùi vào 1 chút (Vừa sửa vừa xóa)
				untracked = { text = "┆" }, -- Vạch đứt (File mới chưa git add)
			},

			-- Bật cột hiển thị icon
			signcolumn = true,

			-- [Thực chiến]: Tự động highlight background của số dòng (line number)
			-- Giúp nhìn cực nhanh vùng code nào đang bị thay đổi mà không cần liếc sang trái
			numhl = false,

			watch_gitdir = {
				follow_files = true,
			},
			attach_to_untracked = true,

			-- [Pro Tip]: Bật tính năng Git Blame trên dòng hiện tại.
			-- Cực kỳ hữu ích khi debug để biết ai là người commit dòng code này và vào lúc nào.
			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- Hiện text mờ ảo ở cuối dòng (End Of Line)
				delay = 500, -- Delay 0.5s sau khi dừng con trỏ thì mới hiện chữ (tránh lag)
			},
		}
	end,
}
