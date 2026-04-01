return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			options = {
				-- 🚀 "auto" sẽ tự động extract màu từ theme hiện tại (Tokyonight, VSCode, v.v.)
				theme = "auto",
				-- 🚀 Chuẩn hiện đại: Dùng 1 thanh status duy nhất cho toàn bộ Neovim
				globalstatus = true,

				component_separators = { left = "│", right = "│" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				-- Bên trái
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = {
					"filename",

					-- 🛠️ Thực chiến: Component tự chế để báo hiệu đang Record Macro
					{
						function()
							local reg = vim.fn.reg_recording()
							if reg == "" then
								return ""
							end -- Không record thì tàng hình
							return "⏺ Recording @" .. reg
						end,
						-- Cờ `cond` giúp Lualine biết khi nào nên vẽ component này
						cond = function()
							return vim.fn.reg_recording() ~= ""
						end,
						color = { fg = "#ff9e64", gui = "bold" }, -- Màu cam báo động
					},
				},

				-- Bên phải
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		},
	},
}
