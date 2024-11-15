return {
    ---@type LazyPluginSpec
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
            "williamboman/mason.nvim",
            {
                "jay-babu/mason-null-ls.nvim",
                dependencies = {
                    "williamboman/mason.nvim",
                    "nvimtools/none-ls.nvim",
                    "nvim-lua/plenary.nvim",
                },
                config = function()
                    local null_ls = require("null-ls")

                    require("null-ls").setup({
                        sources = {
                            null_ls.builtins.formatting.stylua,
                            null_ls.builtins.formatting.prettier,
                            null_ls.builtins.formatting.shfmt,
                            null_ls.builtins.formatting.clang_format.with({
                                filetypes = { "c", "cpp", "cc", "hpp", "h" },
                                extra_args = {
                                    "-style={ BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4, UseTab: Always, AccessModifierOffset: -4, ColumnLimit: 0, BreakBeforeBraces: Custom, BraceWrapping: { AfterClass: false, AfterControlStatement: false, AfterEnum: false, AfterFunction: false, AfterNamespace: false, AfterObjCDeclaration: false, AfterStruct: false, AfterUnion: false, BeforeCatch: true, BeforeElse: true, IndentBraces: false}, ConstructorInitializerAllOnOneLineOrOnePerLine: false, ConstructorInitializerIndentWidth: 4, IndentCaseLabels: false, MaxEmptyLinesToKeep: 1, PointerAlignment: Left, ReflowComments: false, SortIncludes: false, NamespaceIndentation: All, ContinuationIndentWidth: 4, AllowAllArgumentsOnNextLine: false, AllowAllParametersOfDeclarationOnNextLine: false, AllowShortBlocksOnASingleLine: false, AllowShortCaseLabelsOnASingleLine: false, AllowShortFunctionsOnASingleLine: Empty, AllowShortIfStatementsOnASingleLine: false, AllowShortLoopsOnASingleLine: false, AlwaysBreakTemplateDeclarations: true, BreakConstructorInitializersBeforeComma: true, BinPackArguments: true, BinPackParameters: true}",
                                },
                            }),
                            null_ls.builtins.diagnostics.cppcheck,
                        },
                    })
                    require("mason-null-ls").setup({
                        ensure_installed = nil,
                        automatic_installation = true,
                    })
                end
            }
        },
        config = function()
            local lspconfig = require("lspconfig")

            local M = {}

            M.on_attach = function(client, bufnr)
                if client.name == "clangd" then
                    client.server_capabilities.documentFormattingProvider = false -- 0.8 and later
                end
                if vim.fn.has("nvim-0.10") == 1 then
                    print("Connected to: " .. client.name)
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

            -- local signs = { Error = "✘", Warn = "󱡃", Hint = "󱐮", Info = "󱓔" }
            local signs = { Error = "✘", Warn = "󱡃", Hint = ">>", Info = ">>" }

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
}
