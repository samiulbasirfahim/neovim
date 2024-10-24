return {
	{
		"echasnovski/mini.icons",
		init = function()
			package.preload["nvim-web-devicons"] = function()
				package.loaded["nvim-web-devicons"] = {}
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
		config = function()
			require("mini.icons").setup({
				extension = {
					h = { glyph = "󰡱", hl = "MiniIconsCyan" },
				},
			})
		end,
	},
	{
		"echasnovski/mini.files",
		keys = function()
			vim.keymap.set({ "n" }, "<leader>e", function()
				local _ = require("mini.files").close() or require("mini.files").open()
			end, { noremap = true, silent = true, desc = "Toggle minifiles" })
		end,
	},
}
