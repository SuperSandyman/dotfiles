local M = {}

local function keys(value)
	return vim.api.nvim_replace_termcodes(value, true, false, true)
end

function M.continue_list()
	local line = vim.api.nvim_get_current_line()
	local column = vim.api.nvim_win_get_cursor(0)[2]

	-- Splitting an item in the middle should remain a normal newline.
	if column ~= #line then
		return nil
	end

	local _, bullet, task, text = line:match("^(%s*)([-+*])%s+%[([ xX])%]%s*(.*)$")
	if bullet then
		if text == "" then
			return keys("<C-o>0<C-o>D")
		end
		return keys("<CR>" .. bullet .. " [ ] ")
	end

	local _, marker, item = line:match("^(%s*)([-+*])%s+(.*)$")
	if marker then
		if item == "" then
			return keys("<C-o>0<C-o>D")
		end
		return keys("<CR>" .. marker .. " ")
	end

	local _, number, delimiter, numbered_item = line:match("^(%s*)(%d+)([.)])%s+(.*)$")
	if number then
		if numbered_item == "" then
			return keys("<C-o>0<C-o>D")
		end
		return keys(("<CR>%d%s "):format(tonumber(number) + 1, delimiter))
	end

	return nil
end

return M
