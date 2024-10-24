require(".opts")
require(".autocmd")
require(".keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    install = { colorscheme = { "gruvbox-material" } },
    spec = { { import = "plugins" } },
    ui = { border = "single" },
    checker = { enabled = true, notify = false },
    change_detection = { notify = false },

    performance = {
        cache = { enabled = true },
        reset_packpath = true,
        rtp = { disabled_plugins = {} },
    },
})
