return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local keymap = vim.keymap.set

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("ReaderLsp", { clear = true }),
				callback = function(event)
					local opts = { buffer = event.buf }
					local client = vim.lsp.get_client_by_id(event.data.client_id)

					if client and client:supports_method("textDocument/completion") then
						vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
					end

					keymap(
						"n",
						"gd",
						vim.lsp.buf.definition,
						vim.tbl_extend("force", opts, { desc = "定義へ移動" })
					)
					keymap(
						"n",
						"gD",
						vim.lsp.buf.declaration,
						vim.tbl_extend("force", opts, { desc = "宣言へ移動" })
					)
					keymap(
						"n",
						"gi",
						vim.lsp.buf.implementation,
						vim.tbl_extend("force", opts, { desc = "実装へ移動" })
					)
					keymap(
						"n",
						"gr",
						vim.lsp.buf.references,
						vim.tbl_extend("force", opts, { desc = "参照を表示" })
					)
					keymap("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "ホバー情報" }))
					keymap(
						"n",
						"<leader>ca",
						vim.lsp.buf.code_action,
						vim.tbl_extend("force", opts, { desc = "コードアクション" })
					)
					keymap(
						"n",
						"<leader>rn",
						vim.lsp.buf.rename,
						vim.tbl_extend("force", opts, { desc = "名前を変更" })
					)
					keymap(
						"n",
						"<leader>sd",
						vim.diagnostic.open_float,
						vim.tbl_extend("force", opts, { desc = "行の診断を表示" })
					)
					keymap("n", "]d", function()
						vim.diagnostic.jump({ count = 1, float = true })
					end, vim.tbl_extend("force", opts, { desc = "次の診断へ" }))
					keymap("n", "[d", function()
						vim.diagnostic.jump({ count = -1, float = true })
					end, vim.tbl_extend("force", opts, { desc = "前の診断へ" }))
					keymap("i", "<C-Space>", function()
						vim.lsp.completion.get()
					end, vim.tbl_extend("force", opts, { desc = "補完を表示" }))
				end,
			})

			vim.diagnostic.config({
				virtual_text = false,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			local servers = {
				lua_ls = {
					cmd = "lua-language-server",
					config = {
						capabilities = capabilities,
						settings = {
							Lua = {
								diagnostics = { globals = { "vim", "Snacks" } },
								workspace = { checkThirdParty = false },
								telemetry = { enable = false },
							},
						},
					},
				},
				bashls = { cmd = "bash-language-server", config = { capabilities = capabilities } },
				cssls = { cmd = "vscode-css-language-server", config = { capabilities = capabilities } },
				elixirls = { cmd = "elixir-ls", config = { capabilities = capabilities } },
				html = { cmd = "vscode-html-language-server", config = { capabilities = capabilities } },
				jsonls = { cmd = "vscode-json-language-server", config = { capabilities = capabilities } },
				rust_analyzer = { cmd = "rust-analyzer", config = { capabilities = capabilities } },
				ts_ls = { cmd = "typescript-language-server", config = { capabilities = capabilities } },
				yamlls = { cmd = "yaml-language-server", config = { capabilities = capabilities } },
			}

			for server, server_opts in pairs(servers) do
				if vim.fn.executable(server_opts.cmd) == 1 then
					vim.lsp.config(server, server_opts.config)
					vim.lsp.enable(server)
				end
			end
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
			},
			current_line_blame = false,
			preview_config = { border = "rounded" },
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				vim.keymap.set("n", "]h", gs.next_hunk, { buffer = bufnr, desc = "次の Git 変更へ" })
				vim.keymap.set("n", "[h", gs.prev_hunk, { buffer = bufnr, desc = "前の Git 変更へ" })
				vim.keymap.set(
					"n",
					"<leader>gp",
					gs.preview_hunk,
					{ buffer = bufnr, desc = "Git 変更をプレビュー" }
				)
			end,
		},
	},

	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				desc = "コードを整形",
			},
		},
		opts = {
			formatters_by_ft = {
				css = { "prettier" },
				elixir = { "mix" },
				html = { "prettier" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				json = { "prettier" },
				lua = { "stylua" },
				markdown = { "prettier" },
				rust = { "rustfmt" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				yaml = { "prettier" },
			},
			format_on_save = function(bufnr)
				local disabled = { "markdown" }
				if vim.tbl_contains(disabled, vim.bo[bufnr].filetype) then
					return
				end

				return { timeout_ms = 1200, lsp_format = "fallback" }
			end,
		},
	},

	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		opts = { auto_close = true, use_diagnostic_signs = true },
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "診断一覧" },
			{ "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "シンボル一覧" },
			{ "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix 一覧" },
		},
	},
}
