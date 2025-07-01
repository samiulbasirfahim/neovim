return {
	{
		-- lua/plugins/rose-pine.lua
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			require("rose-pine").setup({
				styles = {
					bold = true,
					italic = true,
					transparency = not vim.g.neovide,
				},
			})
			vim.cmd("colorscheme rose-pine")
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {

			cmdline = {
				enabled = true,
				view = "cmdline",
			},
			routes = {
				{
					view = "notify",
					filter = { event = "msg_showmode" },
				},
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
	},
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
					h = { glyph = "", hl = "MiniIconsCyan" },
					norg = { glyph = "", hl = "MiniIconsCyan" },
				},
			})
		end,
	},

	--@type LazyPluginSpec
	{
		"echasnovski/mini.statusline",
		config = function()
			vim.api.nvim_create_autocmd("RecordingEnter", {
				pattern = "*",
				callback = function()
					vim.cmd("redrawstatus")
				end,
			})
			vim.api.nvim_create_autocmd("RecordingLeave", {
				pattern = "*",
				callback = function()
					vim.cmd("redrawstatus")
				end,
			})

			require("mini.statusline").setup({
				content = {
					active = function()
						local check_macro_recording = function()
							if vim.fn.reg_recording() ~= "" then
								return "󰑋  @" .. vim.fn.reg_recording()
							else
								return ""
							end
						end

						local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
						local git = MiniStatusline.section_git({ trunc_width = 40 })
						local diff = MiniStatusline.section_diff({ trunc_width = 75 })
						local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
						local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
						local filename = MiniStatusline.section_filename({ trunc_width = 140 })
						local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
						local location = MiniStatusline.section_location({ trunc_width = 75 })
						local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
						local macro = check_macro_recording()

						return MiniStatusline.combine_groups({
							{ hl = mode_hl, strings = { mode } },
							{ hl = "ModeMsg", strings = { macro } },
							{ hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
							"%<", -- Mark general truncate point
							{ hl = "MiniStatuslineFilename", strings = { filename } },
							"%=", -- End left alignment
							{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
							{ hl = mode_hl, strings = { search, location } },
						})
					end,
				},
			})
		end,
	},

	---@type LazyPluginSpec
	{
		"folke/which-key.nvim",
		dependencies = {
			"echasnovski/mini.icons",
		},
		config = function()
			local wk = require("which-key")
			wk.setup({
				win = {
					border = "single",
				},
			})
		end,
	},
}
