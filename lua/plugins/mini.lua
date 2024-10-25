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
                },
            })
        end,
    },
    {
        "echasnovski/mini.files",
        keys =
        { {
            '<leader>e',
            function()
                local _ = require("mini.files").close() or require("mini.files").open()
            end,
            mode = 'n',
            desc = '[E]xplorer',
        }, },
        config = function()
            require("mini.files").setup {
                use_as_default_explorer = true,
                windows = {
                    max_number = math.huge,
                    preview = false,
                    width_focus = 30,
                    width_nofocus = 20,
                    width_preview = 25,
                },
            }
        end
    },
    {
        "echasnovski/mini.surround",
        config = function()
            require("mini.surround").setup()
        end,
    },
}
