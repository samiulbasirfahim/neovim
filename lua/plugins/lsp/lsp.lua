--@type LazyPluginSpe
return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
        "williamboman/mason.nvim",
        {
            "MysticalDevil/inlay-hints.nvim",
            event = "LspAttach",
            dependencies = { "neovim/nvim-lspconfig" },
            config = function()
                require("inlay-hints").setup()
            end,
        },
    },
    config = function()
        local lspconfig = require("lspconfig")
        local M = {}
        M.on_attach = function(client, bufnr)
            if client.name == "svelte" then
                vim.api.nvim_create_autocmd("BufWritePost", {
                    pattern = { "*.js", "*.ts" },
                    group = vim.api.nvim_create_augroup("svelte_ondidchangetsorjsfile", { clear = true }),
                    callback = function(ctx)
                        -- Here use ctx.match instead of ctx.file
                        client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
                    end,
                })
            end

            if client.name == "clangd" then
                client.server_capabilities.documentFormattingProvider = false -- 0.8 and later
            end

            require("inlay-hints").on_attach(client, bufnr)
            if vim.fn.has("nvim-0.10") == 1 then
                vim.lsp.inlay_hint.enable()
            end
        end
        M.capabilities = vim.lsp.protocol.make_client_capabilities()
        M.capabilities = require("cmp_nvim_lsp").default_capabilities(M.capabilities)
        require("mason").setup({})

        require("mason-lspconfig").setup({
            automatic_installation = true,
            ensure_installed = {
                "lua_ls",
                "clangd",
            },
        })
        require("mason-lspconfig").setup_handlers({
            function(server)
                lspconfig[server].setup({
                    on_attach = M.on_attach,
                    capabilities = M.capabilities,
                })
            end,
            ["ts_ls"] = function()
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
            end,
            ["clangd"] = function()
                lspconfig.clangd.setup({
                    settings = {
                        clangd = {
                            InlayHints = {
                                Designators = true,
                                Enabled = true,
                                ParameterNames = true,
                                DeducedTypes = true,
                            },
                            fallbackFlags = { "-std=c++20" },
                        },
                    },
                })
            end,
            ["svelte"] = function()
                lspconfig.svelte.setup({
                    settings = {
                        typescript = {
                            inlayHints = {
                                parameterNames = { enabled = "all" },
                                parameterTypes = { enabled = true },
                                variableTypes = { enabled = true },
                                propertyDeclarationTypes = { enabled = true },
                                functionLikeReturnTypes = { enabled = true },
                                enumMemberValues = { enabled = true },
                            },
                        },
                    },
                })
            end,
            ["rust_analyzer"] = function()
                lspconfig.rust_analyzer.setup({
                    on_attach = M.on_attach,
                    capabilities = M.capabilities,
                    settings = {
                        ["rust-analyzer"] = {

                            imports = {
                                granularity = {
                                    group = "module",
                                },
                                prefix = "self",
                            },
                            cargo = {
                                buildScripts = {
                                    enable = true,
                                },
                            },
                            procMacro = {
                                enable = true,
                            },
                            inlayHints = {
                                bindingModeHints = {
                                    enable = false,
                                },
                                chainingHints = {
                                    enable = true,
                                },
                                closingBraceHints = {
                                    enable = true,
                                    minLines = 25,
                                },
                                closureReturnTypeHints = {
                                    enable = "never",
                                },
                                lifetimeElisionHints = {
                                    enable = "never",
                                    useParameterNames = false,
                                },
                                maxLength = 25,
                                parameterHints = {
                                    enable = true,
                                },
                                reborrowHints = {
                                    enable = "never",
                                },
                                renderColons = true,
                                typeHints = {
                                    enable = true,
                                    hideClosureInitialization = false,
                                    hideNamedConstructor = false,
                                },
                            },
                        },
                    },
                })
            end,
            ["lua_ls"] = function()
                lspconfig.lua_ls.setup({
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" },
                            },
                            hint = {
                                enable = true,
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
            end,
        })

        local signs = { Error = "✘", Warn = "", Hint = "", Info = "" }
        -- local signs = { Error = "✘", Warn = "󱡃", Hint = ">>", Info = ">>" }

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

        require("core.utility").map({
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
                key = "<leader>li",
                action = ":lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>",
                mode = "n",
                desc = "Disable [i]nlaay hints",
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
        })

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = "single",
        })

        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            border = "single",
        })

        vim.o.updatetime = 100
        vim.api.nvim_create_autocmd({ "CursorHold" }, {
            pattern = "*",
            callback = function()
                vim.diagnostic.open_float(nil, { focus = false })
            end,
        })

        vim.api.nvim_create_autocmd("InsertEnter", {
            pattern = "*",
            callback = function()
                vim.diagnostic.hide()
            end,
        })
    end,
}
