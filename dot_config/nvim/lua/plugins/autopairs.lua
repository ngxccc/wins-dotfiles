return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",

	opts = {
		check_ts = true,
		ts_config = {
			lua = { "string", "source" }, -- bỏ qua pair trong cả string và source code thô của Lua
			javascript = { "template_string" },
			java = false, -- Đôi khi TS check trên Java khá lag, có thể tắt đi (Edge case)
		},
		disable_filetype = { "TelescopePrompt", "spectre_panel" }, -- Tránh autopair làm phiền ở thanh tìm kiếm
		fast_wrap = {
			map = "<M-e>", -- Bấm Alt + E để bọc ngoặc siêu tốc (FastWrap mechanism)
			chars = { "{", "[", "(", '"', "'" },
			pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
			offset = 0, -- Dịch chuyển con trỏ sau khi wrap
			end_key = "$",
			keys = "qwertyuiopzxcvbnmasdfghjkl",
			check_comma = true,
			highlight = "PmenuSel",
			highlight_grey = "LineNr",
		},
	},

	-- 🛠️ Thực chiến: Dùng `config` function CHỈ khi cần setup thêm logic nâng cao (hooking)
	config = function(_, opts)
		-- Bước 1: Vẫn để Lazy tự động setup các `opts` ở trên
		require("nvim-autopairs").setup(opts)

		-- Bước 2: Bắt tay (Handshake) với nvim-cmp để auto thêm ngoặc () khi chọn completion
		local cmp_autopairs_status, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
		if not cmp_autopairs_status then
			return -- Tránh crash Neovim nếu chưa cài nvim-cmp
		end

		local cmp_status, cmp = pcall(require, "cmp")
		if not cmp_status then
			return
		end

		-- Lắng nghe event "confirm_done" của CMP để kích hoạt autopairs
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
