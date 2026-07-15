return {
	{ "nvim-tree/nvim-web-devicons", lazy = true },

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "helix",
			delay = 150,
			spec = {
				{ "<leader>c", group = "コード" },
				{ "<leader>f", group = "ファイル検索" },
				{ "<leader>g", group = "検索 / Git" },
				{ "<leader>m", group = "Markdown" },
				{ "<leader>o", group = "アウトライン" },
				{ "<leader>p", group = "PR レビュー" },
				{ "<leader>r", group = "履歴 / 名前変更" },
				{ "<leader>s", group = "診断 / シンボル" },
				{ "<leader>t", group = "タブ" },
				{ "<leader>u", group = "折り畳み" },
				{ "<leader>x", group = "一覧表示" },
			},
			win = { border = "rounded" },
		},
	},

	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = "onedark",
				globalstatus = true,
				component_separators = "",
				section_separators = { left = "", right = "" },
				disabled_filetypes = { statusline = { "dashboard", "snacks_dashboard" } },
			},
			sections = {
				lualine_a = { {
					"mode",
					fmt = function(mode)
						return mode:sub(1, 1)
					end,
				} },
				lualine_b = { "branch", "diff" },
				lualine_c = { { "filename", path = 1, symbols = { modified = " ●", readonly = " " } } },
				lualine_x = { "diagnostics", "encoding", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		},
	},
}
