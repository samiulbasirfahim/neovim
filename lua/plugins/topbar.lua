return {
    {
        "Bekaboo/dropbar.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("dropbar").setup()
            vim.keymap.set("n", "<leader>p", function()
                require("dropbar.api").pick(vim.v.count ~= 0 and vim.v.count)
            end, { desc = "Toggle dropbar", silent = true, noremap = true })
        end,
    },
}
