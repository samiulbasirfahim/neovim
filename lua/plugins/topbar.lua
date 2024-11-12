return {
    {
        "willothy/nvim-cokeline",
        dependencies = {
            "nvim-lua/plenary.nvim", -- Required for v0.4.0+
        },
        config = function()
            require("cokeline").setup()
            vim.keymap.set(
                "n",
                "<S-Tab>",
                "<Plug>(cokeline-focus-prev)",
                { noremap = true, silent = true, desc = "Prev buffer" }
            )
            vim.keymap.set(
                "n",
                "<Tab>",
                "<Plug>(cokeline-focus-next)",
                { noremap = true, silent = true, desc = "Next buffer" }
            )

            vim.keymap.set("n", "<leader>x", ":bdelete<CR>", { noremap = true, silent = true, desc = "Kill buffer" })
        end,
    },
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
