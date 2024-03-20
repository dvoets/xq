local M = {}

function M.is_regular_buffer()
	local bufnr = vim.api.nvim_get_current_buf()
	return vim.api.nvim_buf_get_option(bufnr, "buftype") == ""
end

function M.is_unsaved_buffer()
	local bufnr = vim.api.nvim_get_current_buf()
	return vim.api.nvim_buf_get_name(bufnr) == ""
end

function M.is_empty_buffer()
	local bufnr = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	return #lines == 0 or (#lines == 1 and lines[1] == "")
end

function M.close_buffer()
	local n_regular_buffers = #vim.fn.getbufinfo({ buflisted = 1 })

	if M.is_regular_buffer() then
		if M.is_unsaved_buffer() or not vim.bo.modified or M.is_empty_buffer() then
			if n_regular_buffers == 1 then
				vim.cmd("q")
			else
				vim.cmd("bd")
			end
		else
			vim.api.nvim_command('call feedkeys(":wq ")')
		end
	else
		vim.cmd("bd")
	end
end

function M.quit_all()
	vim.cmd("wall")
	if not M.is_unsaved_buffer() or not M.is_empty_buffer() then
		vim.cmd("mks! .session")
	end
	vim.cmd("q!")
end

vim.keymap.set("n", "X", M.close_buffer, { silent = true, noremap = true })
vim.keymap.set("n", "Q", M.quit_all, { silent = true, noremap = true })

return M
