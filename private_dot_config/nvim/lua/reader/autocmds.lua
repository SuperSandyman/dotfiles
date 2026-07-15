local group = vim.api.nvim_create_augroup("ReaderNvim", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = group,
	callback = function()
		vim.highlight.on_yank({ timeout = 120 })
	end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	group = group,
	callback = function()
		if vim.fn.mode() ~= "c" then
			vim.cmd("checktime")
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "help", "man", "qf", "startuptime", "checkhealth" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set(
			"n",
			"q",
			"<cmd>close<cr>",
			{ buffer = event.buf, silent = true, desc = "ウィンドウを閉じる" }
		)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.conceallevel = 2
		vim.opt_local.spell = false
	end,
})

vim.api.nvim_create_user_command("Cheatsheet", function()
	local lines = {
		"# Reader Nvim チートシート",
		"",
		"## まず使うキー",
		"- Space: キーグループを表示",
		"- Space ? : このチートシートを開く",
		"- Space f : ファイルを探す",
		"- Space g : 文字列を検索",
		"- Space o : アウトライン / シンボル",
		"- Space e : ファイルエクスプローラーを表示",
		"- Explorer: 矢印で移動、Enter で開く、Left で閉じる、q で終了",
		"- Explorer: I で gitignore 対象を表示、H で dotfile を表示",
		"- Space z : 集中モード",
		"- Space m r : Markdown 表示を切り替え",
		"- Space w : 折り返しを切り替え",
		"- Space u : 現在位置の折り畳みを開閉",
		"",
		"## LSP / 補完",
		"- gd : 定義へ移動",
		"- gr : 参照を表示",
		"- K : ホバー情報を表示",
		"- Space c a : コードアクション",
		"- Space c f : コードを整形",
		"- Space r n : 名前を変更",
		"- Ctrl-Space : 補完を表示",
		"- Ctrl-y : 補完候補を確定",
		"",
		"## Neovim 標準キー",
		"- / : 現在のファイル内を検索",
		"- n / N : 次 / 前の検索結果へ",
		"- * : カーソル下の単語を検索",
		"- Ctrl-o / Ctrl-i : ジャンプ履歴を戻る / 進む",
		"",
		"q でこのバッファを閉じます。",
	}

	vim.cmd("tabnew")
	vim.bo.buftype = "nofile"
	vim.bo.bufhidden = "wipe"
	vim.bo.swapfile = false
	vim.bo.filetype = "markdown"
	vim.api.nvim_buf_set_name(0, "Reader チートシート")
	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
	vim.keymap.set("n", "q", "<cmd>tabclose<cr>", { buffer = true, silent = true })
end, {})
