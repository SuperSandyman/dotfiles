return {
	{
		"navarasu/onedark.nvim",
		priority = 1000,
		opts = {
			style = "darker",
			transparent = false,
			term_colors = true,
			ending_tildes = false,
			cmp_itemkind_reverse = false,
			code_style = {
				comments = "italic",
				keywords = "bold",
				functions = "none",
				strings = "none",
				variables = "none",
			},
			highlights = {
				CursorLine = { bg = "#2c313c" },
				Folded = { fg = "#7f849c", bg = "#252932" },
				LineNr = { fg = "#5c6370" },
				Visual = { bg = "#3e4452" },
			},
		},
		config = function(_, opts)
			require("onedark").setup(opts)
			require("onedark").load()
		end,
	},
}
