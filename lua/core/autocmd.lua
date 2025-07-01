if vim.fn.argc() == 1 then
	vim.api.nvim_create_autocmd("VimEnter", {
		pattern = "*",
		callback = function()
			vim.api.nvim_set_current_dir(vim.fn.expand("%:p:h"))
		end,
	})
end
