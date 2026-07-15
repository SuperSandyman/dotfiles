local keymap = vim.keymap.set

local function toggle_option(option)
	return function()
		vim.opt_local[option] = not vim.opt_local[option]:get()
	end
end

keymap({ "n", "x" }, "j", "gj", { desc = "表示行で下へ移動" })
keymap({ "n", "x" }, "k", "gk", { desc = "表示行で上へ移動" })
keymap("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "検索ハイライトを消す" })
keymap("n", "<leader>q", "<cmd>quit<cr>", { desc = "閉じる" })
keymap("n", "<leader>Q", "<cmd>quitall<cr>", { desc = "すべて閉じる" })
keymap("n", "<leader>w", toggle_option("wrap"), { desc = "折り返しを切り替え" })
keymap("n", "<leader>n", toggle_option("number"), { desc = "行番号を切り替え" })
keymap("n", "<leader>c", toggle_option("cursorline"), { desc = "カーソル行を切り替え" })
keymap("n", "<leader>u", "za", { desc = "カーソル下の折り畳みを切り替え" })
keymap("n", "<leader>U", "zR", { desc = "すべての折り畳みを開く" })
keymap("n", "<leader><tab>", "<c-^>", { desc = "直前のファイルへ" })
keymap("n", "<leader>h", "<cmd>WhichKey<cr>", { desc = "キーマップヘルプ" })
keymap("n", "<leader>?", "<cmd>Cheatsheet<cr>", { desc = "チートシート" })
keymap("n", "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", { desc = "Markdown 表示を切り替え" })
keymap("n", "<leader>ms", toggle_option("spell"), { desc = "スペルチェックを切り替え" })
