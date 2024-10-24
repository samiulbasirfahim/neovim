---@type LazyPluginSpec
return {
	"hrsh7th/nvim-cmp",
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		"hrsh7th/cmp-buffer", -- source for text in buffer
		"hrsh7th/cmp-path", -- source for file system paths
		"hrsh7th/cmp-nvim-lsp", -- source for lsp
	},
	config = function()
		local cmp = require("cmp")
		-- local lspkind = require("lspkind")

		cmp.setup({
			sources = {
				{ name = "nvim_lsp" },
				{ name = "path" },
			},
		})
	end,
}
