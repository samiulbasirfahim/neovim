local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local options = {
    server = {
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = {"/home/fahim/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin/rust-analyzer"};
    }
}

return options
