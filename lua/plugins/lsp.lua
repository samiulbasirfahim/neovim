---@type LazyPluginSpec
return {
	"neovim/nvim-lspconfig",
	dependencies = {},

	config = function()
		local lspconfig = require("lspconfig")

		local servers = { "rust_analyzer", "clangd", "ts_ls", "lua_ls" }

		local M = {}
		M.on_attach = function()
			if vim.fn.has("nvim-0.10") == 1 then
				vim.lsp.inlay_hint.enable()
			end
		end

		M.capabilities = vim.lsp.protocol.make_client_capabilities()

		for _, server in ipairs(servers) do
			lspconfig[server].setup({
				on_attach = M.on_attach,
				capabilities = M.capabilities,
			})
		end

		lspconfig.ts_ls.setup({
			settings = {
				typescript = {
					inlayHints = {
						includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
						includeInlayParameterNameHintsWhenArgumentMatchesName = true,
						includeInlayVariableTypeHints = true,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHintsWhenTypeMatchesName = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
				},
				javascript = {
					inlayHints = {
						includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
						includeInlayParameterNameHintsWhenArgumentMatchesName = true,
						includeInlayVariableTypeHints = true,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHintsWhenTypeMatchesName = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
				},
			},
		})

		lspconfig.lua_ls.setup({
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
							[vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
						},
					},
				},
			},
		})
	end,
}
