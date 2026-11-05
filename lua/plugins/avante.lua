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
        "marcinjahn/gemini-cli.nvim",
        cmd = "Gemini",
        keys = {
            { "<leader>a/", "<cmd>Gemini toggle<cr>",   desc = "Toggle Gemini CLI" },
            { "<leader>aa", "<cmd>Gemini ask<cr>",      desc = "Ask Gemini",       mode = { "n", "v" } },
            { "<leader>af", "<cmd>Gemini add_file<cr>", desc = "Add File" },
        },
        dependencies = { "folke/snacks.nvim" },
        config = true,
    },
}
