return {
	"jay-babu/mason-null-ls.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"nvimtools/none-ls.nvim",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local null_ls = require("null-ls")

		require("null-ls").setup({
			sources = {
				null_ls.builtins.formatting.clang_format.with({
					filetypes = { "c", "cpp", "cc", "hpp", "h" },
					extra_args = {
						"--style",
						"{BasedOnStyle: llvm, IndentWidth: 4}",
					},
				}),
			},
		})

		local mason = require("mason-null-ls")
		require("mason-null-ls").setup({
			ensure_installed = { "stylua", "shfmt", "prettierd" },
			automatic_installation = false,
			handlers = {
				mason.default_setup,
				clang_format = function()
					null_ls.register(null_ls.builtins.formatting.clang_format.with({
						filetypes = { "c", "cpp", "cc", "hpp", "h" },
						extra_args = {
							"--style",
							"{BasedOnStyle: llvm, IndentWidth: 4}",
						},
					}))
				end,
				shfmt = function()
					null_ls.register(null_ls.builtins.formatting.shfmt.with({
						extra_args = {
							"--indent",
							"4",
						},
					}))
				end,
			},
		})
	end,
}
