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
                    h = { glyph = "", hl = "MiniIconsCyan" },
                    norg = { glyph = "", hl = "MiniIconsCyan" },
                },
            })
        end,
    },
    {
        "echasnovski/mini.files",
        keys = {
            {
                "<leader>e",
                function()
                    local _ = require("mini.files").close() or require("mini.files").open()
                end,
                mode = "n",
                desc = "[E]xplorer",
            },
        },
        config = function()
            require("mini.files").setup({
                use_as_default_explorer = true,
                windows = {
                    max_number = math.huge,
                    preview = false,
                    width_focus = 20,
                    width_nofocus = 20,
                    width_preview = 20,
                },
                mappings = {
                    mark_goto = "@",
                    reveal_cwd = "'",
                },
            })
        end,
    },
    {
        "echasnovski/mini.surround",
        config = function()
            require("mini.surround").setup()
        end,
    },
    ---@type LazyPluginSpec
    {
        "echasnovski/mini.pick",
        dependencies = { "echasnovski/mini.extra", "echasnovski/mini.fuzzy" },
        config = function()
            local minipick = require("mini.pick")
            local miniextra = require("mini.extra")
            -- local minivisits = require("mini.visits")
            local builtin = minipick.builtin

            vim.ui.select = minipick.ui_select

            miniextra.setup()
            require("mini.fuzzy").setup()

            minipick.setup({
                mappings = {
                    move_down = "<C-j>",
                    move_start = "<C-g>",
                    move_up = "<C-k>",
                },
            })

            local keymaps = {
                {
                    mode = "n",
                    key = "<leader>ff",
                    action = function()
                        builtin.files({ tool = "rg" })
                    end,
                    desc = "Find [f]iles",
                },
                {
                    mode = "n",
                    key = "<leader>fr",
                    action = function()
                        builtin.resume()
                    end,
                    desc = "[R]esume finding",
                },
                {
                    mode = "n",
                    key = "<leader>fg",
                    action = function()
                        builtin.grep_live({ tool = "rg" })
                    end,
                    desc = "Live [g]rep",
                },
                {
                    mode = "n",
                    key = "<leader>fb",
                    action = function()
                        builtin.buffers()
                    end,
                    desc = "Find [b]uffer",
                },
                {
                    mode = "n",
                    key = "<leader>fh",
                    action = function()
                        builtin.help()
                    end,
                    desc = "Find [h]elp",
                },
                {
                    mode = "n",
                    key = "<leader>fw",
                    action = function()
                        miniextra.pickers.buf_lines()
                    end,
                    desc = "Find [w]ord",
                },

                {
                    mode = "n",
                    key = "<leader>fk",
                    action = function()
                        miniextra.pickers.keymaps()
                    end,
                    desc = "[K]eymaps",
                },

                {
                    mode = "n",
                    key = "<leader>fld",
                    action = function()
                        miniextra.pickers.lsp({ scope = "declaration" })
                    end,
                    desc = "[D]eclaration",
                },

                {
                    mode = "n",
                    key = "<leader>flr",
                    action = function()
                        miniextra.pickers.lsp({ scope = "references" })
                    end,
                    desc = "[R]eferences",
                },

                {
                    mode = "n",
                    key = "<leader>fli",
                    action = function()
                        miniextra.pickers.lsp({ scope = "implementation" })
                    end,
                    desc = "[I]mplementation",
                },

                {
                    mode = "n",
                    key = "<leader>fls",
                    action = function()
                        miniextra.pickers.lsp({ scope = "document_symbol" })
                    end,
                    desc = "[S]symbol",
                },

                {
                    mode = "n",
                    key = "<leader>flt",
                    action = function()
                        miniextra.pickers.lsp({ scope = "type_definition" })
                    end,
                    desc = "[T]ype definition",
                },

                {
                    mode = "n",
                    key = "<leader>flw",
                    action = function()
                        miniextra.pickers.lsp({ scope = "workspace_symbol" })
                    end,
                    desc = "[W]orkspace symbol",
                },

                {
                    mode = "n",
                    key = "<leader>flD",
                    action = function()
                        miniextra.pickers.lsp({ scope = "definition" })
                    end,
                    desc = "[D]efinition",
                },
                {
                    mode = "n",
                    key = "<leader>fd",
                    action = function()
                        miniextra.pickers.diagnostic()
                    end,
                    desc = "[D]iagnostics",
                },
                {
                    mode = "n",
                    key = "<leader>fo",
                    action = function()
                        miniextra.pickers.oldfiles()
                    end,
                    desc = "Find [o]oldfiles",
                },

                {
                    mode = "n",
                    key = "<leader>fe",
                    action = function()
                        miniextra.pickers.explorer()
                    end,
                    desc = "[E]xplorer",
                },
                {
                    mode = "n",
                    key = "<leader>fc",
                    action = function()
                        miniextra.pickers.git_commits()
                    end,
                    desc = "Git [c]ommits",
                },
            }

            local function map(mode, key, action, desc)
                vim.keymap.set(mode, key, action, { noremap = true, silent = true, desc = desc })
            end

            for _, keymap in ipairs(keymaps) do
                map(keymap.mode, keymap.key, keymap.action, keymap.desc)
            end
        end,
    },
    {
        "echasnovski/mini.indentscope",
        config = function()
            require("mini.indentscope").setup({
                draw = {
                    delay = 0,
                    animation = function()
                        return 0
                    end,
                },
                options = { try_as_border = true, border = "both", indent_at_cursor = true },
            })
        end,
    },
    {
        "echasnovski/mini.comment",
        config = function()
            require("mini.comment").setup()
        end,
    },
}
