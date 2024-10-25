return {
    ---@type LazyPluginSpec
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            ---@type LazyPluginSpec
            {
                "nvimtools/none-ls.nvim",
                dependencies = "nvim-lua/plenary.nvim",
                config = function()
                    local null_ls = require("null-ls")
                    null_ls.setup({
                        sources = {
                            -- Formatter
                            null_ls.builtins.formatting.stylua,
                            null_ls.builtins.formatting.prettier,
                            null_ls.builtins.formatting.shfmt,

                            null_ls.builtins.formatting.clang_format.with({
                                extra_args = { "-style=", '"{IndentWidth: 4}"' },
                            }),

                            -- Code actions
                            -- Diagnostic
                            null_ls.builtins.diagnostics.cppcheck,
                        },
                    })
                end,
            },
        },

        config = function()
            local lspconfig = require("lspconfig")

            local servers = { "rust_analyzer", "clangd", "ts_ls", "lua_ls" }

            local lsp_formatting = function(bufnr)
                vim.lsp.buf.format({
                    filter = function(client)
                        return client.name == "null-ls"
                    end,
                    bufnr = bufnr,
                })
            end

            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

            local M = {}

            M.on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            lsp_formatting(bufnr)
                        end,
                    })
                end
                if vim.fn.has("nvim-0.10") == 1 then
                    print("Lsp server connected")
                    vim.lsp.inlay_hint.enable()
                end
            end

            M.capabilities = vim.lsp.protocol.make_client_capabilities()
            M.capabilities = require("cmp_nvim_lsp").default_capabilities(M.capabilities)

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

            local signs = { Error = "✘", Warn = "󱡃", Hint = "󱐮", Info = "󱓔" }

            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
                update_in_insert = true,
                underline = true,
                severity_sort = false,
                float = {
                    border = "single",
                    source = true,
                    header = "",
                    prefix = "",
                },
            })

            local keymaps = {

                {
                    key = "<leader>l",
                    action = function() end,
                    mode = "n",
                    desc = "Lsp",
                },
                {
                    key = "<leader>lf",
                    action = function()
                        vim.lsp.buf.format()
                    end,
                    mode = "n",
                    desc = "[F]format file",
                },
                {
                    key = "<leader>ls",
                    action = function()
                        vim.lsp.buf.signature_help()
                    end,
                    mode = "n",
                    desc = "[S]ignature help",
                },
                {
                    key = "<leader>lt",
                    action = function()
                        vim.lsp.buf.type_definition()
                    end,
                    mode = "n",
                    desc = "[T]ype defination",
                },
                {
                    key = "<leader>la",
                    action = function()
                        vim.lsp.buf.code_action()
                    end,
                    mode = "n",
                    desc = "Code [a]ction",
                },
                {
                    key = "<leader>ld",
                    action = function()
                        vim.lsp.buf.definition()
                    end,
                    mode = "n",
                    desc = "Go to [d]efinition",
                },
                {
                    key = "<leader>lD",
                    action = function()
                        vim.lsp.buf.declaration()
                    end,
                    mode = "n",
                    desc = "Go to [d]eclaration",
                },
                {
                    key = "<leader>lR",
                    action = function()
                        vim.lsp.buf.references()
                    end,
                    mode = "n",
                    desc = "Go to [r]eferences",
                },
                {
                    key = "<leader>lr",
                    action = function()
                        vim.lsp.buf.rename()
                    end,
                    mode = "n",
                    desc = "[R]ename",
                },
                {
                    key = "<leader>ln",
                    action = function()
                        vim.diagnostic.goto_next()
                    end,
                    mode = "n",
                    desc = "Go to [n]ext diagnostic",
                },
                {
                    key = "<leader>lp",
                    action = function()
                        vim.diagnostic.goto_prev()
                    end,
                    mode = "n",
                    desc = "Go to [p]rev diagnostic",
                },
            }

            local function map(mode, key, action, desc)
                vim.keymap.set(mode, key, action, { noremap = true, silent = true, desc = desc })
            end

            for _, keymap in ipairs(keymaps) do
                map(keymap.mode, keymap.key, keymap.action, keymap.desc)
            end

            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = "single",
            })

            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
                border = "single",
            })

            vim.o.updatetime = 250
            vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])
        end,
    },

    ---@type LazyPluginSpec
    {},
}
