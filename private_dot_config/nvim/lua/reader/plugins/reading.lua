return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = function()
			if vim.fn.executable("tree-sitter") == 1 then
				require("nvim-treesitter").update():wait(300000)
			end
		end,
		config = function()
			local filetypes = {
				"bash",
				"css",
				"elixir",
				"html",
				"javascript",
				"json",
				"jsonc",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"rust",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			}

			require("nvim-treesitter").setup({})

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("ReaderTreesitter", { clear = true }),
				pattern = filetypes,
				callback = function()
					pcall(vim.treesitter.start)
				end,
			})
		end,
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "Avante", "codecompanion" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			render_modes = true,
			heading = {
				enabled = true,
				sign = true,
				icons = { "󰼏  ", "󰎨  ", "󰼑  ", "󰎲  ", "󰼓  ", "󰎴  " },
				backgrounds = {
					"RenderMarkdownH1Bg",
					"RenderMarkdownH2Bg",
					"RenderMarkdownH3Bg",
					"RenderMarkdownH4Bg",
					"RenderMarkdownH5Bg",
					"RenderMarkdownH6Bg",
				},
			},
			code = {
				enabled = true,
				sign = true,
				style = "full",
				border = "thin",
				language_pad = 1,
			},
			dash = { enabled = true },
			checkbox = { enabled = true },
			quote = { enabled = true },
			table = { enabled = true, style = "full" },
		},
	},

	{
		"kevinhwang91/nvim-ufo",
		event = "BufReadPost",
		dependencies = { "kevinhwang91/promise-async" },
		opts = {
			open_fold_hl_timeout = 120,
			close_fold_kinds_for_ft = {
				default = { "imports", "comment" },
				json = { "array" },
				markdown = {},
			},
			preview = {
				win_config = {
					border = "rounded",
					winblend = 0,
				},
			},
			provider_selector = function(_, filetype)
				if filetype == "markdown" then
					return { "treesitter", "indent" }
				end
				return { "lsp", "indent" }
			end,
		},
		config = function(_, opts)
			require("ufo").setup(opts)
			vim.keymap.set("n", "zK", function()
				local winid = require("ufo").peekFoldedLinesUnderCursor()
				if not winid then
					vim.lsp.buf.hover()
				end
			end, { desc = "折り畳み内容またはホバー情報" })
		end,
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},

	{
		"echasnovski/mini.surround",
		version = false,
		event = "VeryLazy",
		opts = {},
	},

	{
		"folke/todo-comments.nvim",
		event = "BufReadPost",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = true,
			keywords = {
				TODO = { icon = " ", color = "info" },
				NOTE = { icon = " ", color = "hint" },
				HACK = { icon = " ", color = "warning" },
				WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
				PERF = { icon = "󰅒 ", color = "default" },
			},
		},
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "次の TODO コメントへ",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "前の TODO コメントへ",
			},
			{ "<leader>gt", "<cmd>TodoTrouble<cr>", desc = "TODO コメント一覧" },
		},
	},
}
