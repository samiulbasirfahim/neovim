return {
	"yetone/avante.nvim",
	build = "make",
	event = "VeryLazy",
	version = false,
	opts = {
		provider = "gemini",
		gemini = {
			model = "gemini-2.5-pro",
		},

	},
}
