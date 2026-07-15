return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			dashboard = {
				enabled = true,
				sections = {
					{ section = "header" },
					{ icon = " ", title = "Find", section = "keys", indent = 2, padding = 1 },
					{ icon = " ", title = "Recent", section = "recent_files", indent = 2, padding = 1 },
					{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
					{ section = "startup" },
				},
			},
			explorer = { enabled = true, replace_netrw = true },
			indent = {
				enabled = true,
				animate = { enabled = false },
				scope = { enabled = true },
			},
			input = { enabled = true },
			notifier = { enabled = true, timeout = 2200 },
			picker = {
				enabled = true,
				layout = { preset = "telescope" },
				matcher = { frecency = true },
				sources = {
					explorer = {
						hidden = true,
						ignored = true,
						win = {
							list = {
								keys = {
									["<Down>"] = "list_down",
									["<Up>"] = "list_up",
									["<Right>"] = "confirm",
									["<Left>"] = "explorer_close",
									["<CR>"] = "confirm",
									["q"] = "close",
								},
							},
						},
					},
				},
				win = {
					input = { keys = { ["<Esc>"] = { "close", mode = { "n", "i" } } } },
				},
			},
			quickfile = { enabled = true },
			scope = { enabled = true },
			scroll = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
			zen = {
				toggles = { dim = true, git_signs = false, mini_diff_signs = false },
				win = { width = 0.82 },
			},
		},
		keys = {
			{
				"<leader>e",
				function()
					local file = vim.api.nvim_buf_get_name(0)
					local picker

					if file ~= "" and vim.fn.filereadable(file) == 1 then
						picker = Snacks.explorer.reveal({ file = file })
					else
						picker = Snacks.picker.get({ source = "explorer" })[1] or Snacks.explorer.open()
					end

					if picker then
						vim.schedule(function()
							if not picker.closed then
								picker:focus("list", { show = true })
							end
						end)
					end
				end,
				desc = "エクスプローラーを表示",
			},
			{
				"<leader>f",
				function()
					Snacks.picker.files()
				end,
				desc = "ファイルを探す",
			},
			{
				"<leader>g",
				function()
					Snacks.picker.grep()
				end,
				desc = "文字列を検索",
			},
			{
				"<leader>b",
				function()
					Snacks.picker.buffers()
				end,
				desc = "バッファ一覧",
			},
			{
				"<leader>r",
				function()
					Snacks.picker.recent()
				end,
				desc = "最近開いたファイル",
			},
			{
				"<leader>/",
				function()
					Snacks.picker.lines()
				end,
				desc = "現在のバッファ内を検索",
			},
			{
				"<leader>o",
				function()
					Snacks.picker.lsp_symbols()
				end,
				desc = "ドキュメントのアウトライン",
			},
			{
				"<leader>O",
				function()
					Snacks.picker.lsp_workspace_symbols()
				end,
				desc = "ワークスペースシンボル",
			},
			{
				"<leader>z",
				function()
					Snacks.zen()
				end,
				desc = "集中モード",
			},
			{
				"<leader>.",
				function()
					Snacks.scratch()
				end,
				desc = "スクラッチバッファ",
			},
			{
				"<leader>N",
				function()
					Snacks.notifier.show_history()
				end,
				desc = "通知履歴",
			},
		},
	},
}
