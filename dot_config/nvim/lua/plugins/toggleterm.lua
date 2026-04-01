return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x", -- Thực chiến: Luôn lock branch để tránh bị break config khi plugin update
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ -- 🚀 Động cơ V8 cho Telescope
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make", -- Yêu cầu máy bro phải cài gcc/make hoặc cmake
		},
	},
	-- ⚡ LAZY LOADING: Telescope chỉ "tỉnh dậy" khi bro bấm các phím này
	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
		{ "<leader>fa", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find All Files (Hidden)" },
		{ "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
		{ "<leader>fq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix List" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
		{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep (Realtime)" }, -- Đã thay thế input() cồng kềnh
		{ "<leader>fs", "<cmd>Telescope grep_string<cr>", desc = "Grep string under cursor" },
		{
			"<leader>fi",
			function()
				require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "Find Neovim Config",
		},
		{
			"<leader>fc",
			function()
				local filename = vim.fn.expand("%:t:r")
				require("telescope.builtin").grep_string({ search = filename })
			end,
			desc = "Find occurrences of current file",
		},
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				-- UI mượt mà, layout xịn xò
				prompt_prefix = "   ",
				selection_caret = "👉 ",
				path_display = { "truncate" }, -- Cắt bớt path nếu quá dài
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<esc>"] = actions.close, -- Mặc định Telescope bấm Esc trong Insert mode nó không thoát, nên map lại cho quen tay
					},
				},
			},
		})

		-- Kích hoạt extension fzf
		pcall(telescope.load_extension, "fzf")
	end,
}
