return {
	{
		"pwntester/octo.nvim",
		cmd = "Octo",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"folke/snacks.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<leader>pp", "<cmd>Octo pr list<cr>", desc = "PR 一覧" },
			{ "<leader>pP", "<cmd>Octo search is:pr is:open review-requested:@me<cr>", desc = "レビュー依頼 PR" },
			{ "<leader>po", "<cmd>Octo pr edit<cr>", desc = "現在の PR を開く" },
			{ "<leader>px", "<cmd>Octo pr checkout<cr>", desc = "PR を checkout" },
			{ "<leader>pr", "<cmd>Octo review<cr>", desc = "PR レビュー開始" },
			{ "<leader>ps", "<cmd>Octo review submit<cr>", desc = "レビューを送信" },
			{ "<leader>pc", "<cmd>Octo review comments<cr>", desc = "保留中コメント" },
			{ "<leader>pd", "<cmd>Octo review discard<cr>", desc = "レビューを破棄" },
			{ "<leader>pb", "<cmd>Octo pr checks<cr>", desc = "PR チェック" },
			{ "<leader>pu", "<cmd>Octo pr browser<cr>", desc = "PR をブラウザで開く" },
			{ "<leader>p/", "<cmd>Octo search is:pr is:open<cr>", desc = "GitHub PR 検索" },
		},
		opts = {
			picker = "snacks",
			enable_builtin = true,
			default_remote = { "upstream", "origin" },
			reviews = {
				auto_show_threads = true,
				focus = "right",
			},
			pull_requests = {
				order_by = { field = "UPDATED_AT", direction = "DESC" },
			},
			file_panel = {
				size = 12,
			},
			mappings = {
				pull_request = {
					review_start = { lhs = "<localleader>rs", desc = "start PR review" },
					review_resume = { lhs = "<localleader>rr", desc = "resume PR review" },
				},
				review_diff = {
					submit_review = { lhs = "<localleader>rs", desc = "submit review" },
					discard_review = { lhs = "<localleader>rd", desc = "discard review" },
					add_review_comment = { lhs = "<localleader>c", desc = "add review comment", mode = { "n", "x" } },
					add_review_suggestion = {
						lhs = "<localleader>s",
						desc = "add review suggestion",
						mode = { "n", "x" },
					},
					focus_files = { lhs = "<localleader>e", desc = "focus changed files" },
					toggle_files = { lhs = "<localleader>b", desc = "toggle changed files" },
				},
				file_panel = {
					submit_review = { lhs = "<localleader>rs", desc = "submit review" },
					discard_review = { lhs = "<localleader>rd", desc = "discard review" },
				},
				submit_win = {
					approve_review = { lhs = "<C-a>", desc = "approve review", mode = { "n" } },
					comment_review = { lhs = "<C-m>", desc = "comment review", mode = { "n" } },
					request_changes = { lhs = "<C-r>", desc = "request changes review", mode = { "n" } },
				},
			},
		},
	},
}
