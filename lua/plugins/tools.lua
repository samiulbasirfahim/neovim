local leet_arg = "leetcode.nvim"

return {
	{
		"akinsho/toggleterm.nvim",
		config = function()
			local toggleterm = require("toggleterm")
			toggleterm.setup({
				size = 12,
				open_mapping = [[<c-\>]],
				shade_filetypes = {},
				run_tmux = false,
				shade_terminal = true,
				shading_factor = 1,
				start_in_insert = true,
				persist_size = true,
				direction = "horizontal",
				autochdir = true,
			})
			local keymap = vim.keymap -- for conciseness
			keymap.set("n", "<C-\\>", ":ToggleTerm<CR>")
			keymap.set("t", "<C-\\>", "<Cmd>ToggleTerm<CR>")
			vim.keymap.set("t", "<esc>", [[<C-\><C-n>]])
		end,
	},

	{
		"CRAG666/code_runner.nvim",
		event = "BufReadPre",
		keys = {
			{
				"<leader>r",
				":RunCode<CR>",
				"n",
				desc = "Run code",
			},
		},
		config = function()
			local code_runner = require("code_runner")
			code_runner.setup({
				mode = "term",
				startinsert = true,
				filetype = {
					python = "python3 -u",
					typescript = "deno run",
					rust = "cd $dir && cargo run",
					c = "cd $dir && mkdir -p .bin && cd .bin && clang --debug ../$fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
					cpp = "cd $dir && mkdir -p .bin && cd .bin && clang++ --debug ../$fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
				},
				project = {},
			})
		end,
	},

	{
		"mg979/vim-visual-multi",
	},

	{
		"xeluxee/competitest.nvim",
		dependencies = { "muniftanjim/nui.nvim", lazy = true },
		cmd = "CompetiTest",
		keys = {
			{ "<leader>ca", "<CMD>CompetiTest add_testcase<CR>", options, desc = "CP: add testcases" },
			{ "<leader>ce", "<CMD>CompetiTest edit_testcase<CR>", options, desc = "CP: edit testcases" },
			{ "<leader>cd", "<CMD>CompetiTest delete_testcase<CR>", options, desc = "CP: delete testcases" },
			{ "<leader>cr", "<CMD>CompetiTest run<CR>", options, desc = "CP: run testcases" },
			{ "<leader>cp", "<CMD>CompetiTest receive problem<CR>", options, desc = "CP: download testcases" },
			{ "<leader>cD", "<CMD>CompetiTest receive contest<CR>", options, desc = "CP: download contest" },
		},
		opts = {
			received_files_extension = "cpp",
			testcases_directory = "./.tests",
			compile_directory = "./.bin",
			running_directory = "./.bin",
			compile_command = {
				cpp = {
					exec = "clang++", --[[ clang++ | g++ ]]
					args = {
						"-std=c++20",
						"-pedantic",
						"-O2",
						"-Wall",
						"-Wextra",
						"-Wconversion",
						"-Wno-sign-conversion",
						"-Wshadow",
						"../$(FNAME)",
						"-o",
						"$(FNOEXT)",
					},
				},
				c = { exec = "clang", args = { "-Wall", "-Wextra", "-O2", "../$(FNAME)", "-o", "$(FNOEXT)" } },
			},
			run_command = {
				c = { exec = "./$(FNOEXT)" },
				cpp = { exec = "./$(FNOEXT)" },
			},
		},
	},
	{
		"kawre/leetcode.nvim",
		build = ":TSUpdate html",

		cond = vim.fn.argv()[1] == leet_arg,
		lazy = false,
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim", -- required by telescope
			"MunifTanjim/nui.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{
				"<leader>Le",
				"<cmd>Leet menu<cr>",
				desc = "focus dashboard",
			},
			{
				"<leader>Lt",
				"<cmd>Leet desc<cr>",
				desc = "toggle question description",
			},
			{
				"<leader>Ld",
				"<cmd>Leet daily<cr>",
				desc = "opens question of today",
			},
			{
				"<leader>Lc",
				"<cmd>Leet console<cr>",
				desc = "opens question console",
			},
			{
				"<leader>Li",
				"<cmd>Leet info<cr>",
				desc = "opens question information",
			},
			{
				"<leader>Ll",
				"<cmd>Leet lang<cr>",
				desc = "change question language",
			},
			{
				"<leader>Lr",
				"<cmd>Leet run<cr>",
				desc = "run question",
			},
			{
				"<leader>Ls",
				"<cmd>Leet submit<cr>",
				desc = "submit question",
			},
			{
				"<leader>Lf",
				"<cmd>Leet list<cr>",
				desc = "opens problemlist",
			},
			{
				"<leader>Lb",
				"<cmd>Leet tabs<cr>",
				desc = "opens question tabs",
			},
		},
		opts = {
			lang = "cpp",
			storage = {
				home = "$HOME/dev/cp/leetcode",
			},
			description = {
				width = "50%",
			},
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		opts = {
			defaults = {
				mappings = {
					i = {
						["<C-j>"] = "move_selection_next",
						["<C-k>"] = "move_selection_previous",

						["<A-j>"] = "move_selection_next",
						["<A-k>"] = "move_selection_previous",
					},
				},
			},
		},
	},
	{
		"lostl1ght/lazygit.nvim",
		lazy = true,
		cmd = "Lazygit",
		keys = { { "<leader>g", "<cmd>Lazygit<cr>", desc = "Git" } },
	},
	{
		"IogaMaster/neocord",
		event = "VeryLazy",
		config = function()
			require("neocord").setup()
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},
	{
		"alexghergh/nvim-tmux-navigation",
		config = function()
			require("nvim-tmux-navigation").setup({
				disable_when_zoomed = true, -- defaults to false
				keybindings = {
					left = "<C-h>",
					down = "<C-j>",
					up = "<C-k>",
					right = "<C-l>",
					next = "<C-Space>",
				},
			})
		end,
	},

	{
		"karb94/neoscroll.nvim",
		opts = {},
	},

	{
		"Bekaboo/dropbar.nvim",
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		config = function()
			local dropbar_api = require("dropbar.api")
			vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
			vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
			vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
		end,
	},
	{
		"saecki/crates.nvim",
		tag = "stable",
		config = function()
			require("crates").setup({
				lsp = {
					enabled = true,
					on_attach = function(client, bufnr)
						-- the same on_attach function as for your other language servers
						-- can be ommited if you're using the `LspAttach` autocmd
					end,
					actions = true,
					completion = true,
					hover = true,
				},

				null_ls = {
					enabled = true,
					name = "crates.nvim",
				},

				completion = {
					crates = {
						enabled = true,
						max_results = 8,
						min_chars = 3,
					},
				},
			})

			local crates = require("crates")
			local function map(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
			end

			map("n", "<leader>cct", crates.toggle, "Crates: toggle UI")
			map("n", "<leader>ccr", crates.reload, "Crates: reload")

			map("n", "<leader>ccv", crates.show_versions_popup, "Crates: show versions")
			map("n", "<leader>ccf", crates.show_features_popup, "Crates: show features")
			map("n", "<leader>ccd", crates.show_dependencies_popup, "Crates: show dependencies")

			map("n", "<leader>ccu", crates.update_crate, "Crates: update crate")
			map("v", "<leader>ccu", crates.update_crates, "Crates: update selected crates")
			map("n", "<leader>cca", crates.update_all_crates, "Crates: update all crates")
			map("n", "<leader>ccU", crates.upgrade_crate, "Crates: upgrade crate")
			map("v", "<leader>ccU", crates.upgrade_crates, "Crates: upgrade selected crates")
			map("n", "<leader>ccA", crates.upgrade_all_crates, "Crates: upgrade all crates")

			map("n", "<leader>ccx", crates.expand_plain_crate_to_inline_table, "Crates: expand to inline table")
			map("n", "<leader>ccX", crates.extract_crate_into_table, "Crates: extract into table")

			map("n", "<leader>ccH", crates.open_homepage, "Crates: open homepage")
			map("n", "<leader>ccR", crates.open_repository, "Crates: open repository")
			map("n", "<leader>ccD", crates.open_documentation, "Crates: open documentation")
			map("n", "<leader>ccC", crates.open_crates_io, "Crates: open crates.io page")
			map("n", "<leader>ccL", crates.open_lib_rs, "Crates: open lib.rs page")
		end,
	},
}
