vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true
vim.opt_local.conceallevel = 2
vim.opt_local.spell = false
vim.opt_local.textwidth = 0

vim.keymap.set("n", "j", "gj", { buffer = true, silent = true, desc = "表示行で下へ移動" })
vim.keymap.set("n", "k", "gk", { buffer = true, silent = true, desc = "表示行で上へ移動" })
