-- return {
-- 	"yetone/avante.nvim",
-- 	build = "make",
-- 	event = "VeryLazy",
-- 	version = false,
-- 	opts = {
-- 		provider = "gemini",
-- 		gemini = {
-- 			model = "gemini-2.5-pro",
-- 		},
--
-- 	},
-- }

return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				panel = { enabled = true },
				suggestion = { auto_trigger = true },
				filetypes = { markdown = true },
			})
		end,
	},

	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		build = "make tiktoken",
		opts = {
		},
	},
}
