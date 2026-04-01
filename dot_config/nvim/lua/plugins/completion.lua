return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"onsails/lspkind.nvim",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				preselect = cmp.PreselectMode.Item,
				completion = {
					completeopt = "menu,menuone,noinsert",
				},

				-- UI chanh sả, có viền cong giống VS Code
				window = {
					completion = cmp.config.window.bordered({ border = "curved" }),
					documentation = cmp.config.window.bordered({ border = "curved" }),
				},

				mapping = cmp.mapping.preset.insert({
					-- Chấp nhận completion
					["<CR>"] = cmp.mapping.confirm({ select = false }),

					-- Hủy popup
					["<C-e>"] = cmp.mapping.abort(),

					-- Gọi popup thủ công (thường dùng khi lỡ tay bấm Esc tắt popup)
					["<C-Space>"] = cmp.mapping.complete(),

					-- Lướt lên/xuống danh sách
					["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),

					-- Cuộn docs (nếu documentation window đang mở)
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-b>"] = cmp.mapping.scroll_docs(-4), -- Nên dùng C-b thay vì C-u để chuẩn Vim motions (b = backward)

					-- Super Tab logic (nhảy dòng hoặc chọn item)
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback() -- Nếu ko có popup, gõ Tab bình thường
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),

				-- 🚀 Nguồn dữ liệu (Sources) - Sắp xếp theo thứ tự ưu tiên
				sources = cmp.config.sources({
					{ name = "nvim_lsp", priority = 1000 }, -- Ưu tiên LSP nhất
					{ name = "path", priority = 750 }, -- Gợi ý đường dẫn file
				}, {
					{ name = "buffer", keyword_length = 3, priority = 500 }, -- Gợi ý từ đã gõ trong file
				}),
			})
		end,
	},
}
