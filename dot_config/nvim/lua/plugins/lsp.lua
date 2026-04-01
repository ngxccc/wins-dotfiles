return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"saadparwaiz1/cmp_luasnip",
		"L3MON4D3/LuaSnip",
		"rafamadriz/friendly-snippets",
		"b0o/schemastore.nvim",
	},
	config = function()
		-- 1. Setup Mason
		require("mason").setup({ ui = { border = "rounded" } })

		-- 2. Auto Install Tools
		require("mason-tool-installer").setup({
			ensure_installed = {
				"ruff",
				"mypy",
				"stylua",
				"prettier",
				"eslint_d",
				"lua-language-server",
				"typescript-language-server",
				"html-lsp",
				"css-lsp",
				"json-lsp",
			},
		})

		-- 3. Config Diagnostics
		vim.diagnostic.config({
			float = { border = "rounded" },
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "✘",
					[vim.diagnostic.severity.WARN] = "▲",
					[vim.diagnostic.severity.HINT] = "⚑",
					[vim.diagnostic.severity.INFO] = "»",
				},
			},
		})

		-- 4. Capabilities (cho cmp)
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local servers = {
			-- 🐍 Python
			ruff = {
				cmd = { "ruff", "server" },
				filetypes = { "python" },
				root_markers = { "pyproject.toml", ".git" },
			},
			-- 🌐 WebDev
			ts_ls = {
				cmd = { "typescript-language-server", "--stdio" },
				filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
				root_markers = { "package.json", "tsconfig.json", ".git" },
			},
			html = { cmd = { "vscode-html-language-server", "--stdio" } },
			cssls = { cmd = { "vscode-css-language-server", "--stdio" } },
			-- ⚙️ Lõi
			lua_ls = {
				cmd = { "lua-language-server" },
				settings = { Lua = { diagnostics = { globals = { "vim" } } } },
			},
			jsonls = {
				cmd = { "vscode-json-language-server", "--stdio" },
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			},
		}

		-- Vòng lặp thần thánh: Duyệt qua table và enable toàn bộ
		for server, config in pairs(servers) do
			-- Trộn capabilities mặc định vào config của từng server
			config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})

			vim.lsp.config(server, config)
			vim.lsp.enable(server)
		end

		-- 5. LspAttach (Keymaps & Settings)
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }
				-- Keybindings
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
			end,
		})

		-- 9. Setup nvim-cmp (như cũ của bạn, đã rút gọn cho ngắn)
		local cmp = require("cmp")
		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer" },
			}),
		})
	end,
}
