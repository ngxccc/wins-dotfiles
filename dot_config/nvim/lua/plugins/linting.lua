return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			python = { "mypy" }, -- Mypy check type ở đây!
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
		}

		-- Tự động chạy linter mỗi khi lưu file hoặc rảnh tay (InsertLeave)
		vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("UserLinting", { clear = true }),
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
