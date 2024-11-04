local cfg = function()
    local ignore_args_wrapper = function(f)
        return function()
            f()
        end
    end

    local on_lsp_attach = function(event)
        local bufnr = event.buf
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        assert(client)

        -- Enable completion triggered by <C-x><C-o>
        vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- 'c' stands for 'code'
        local bufopts = { noremap = true, silent = true }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', '<Leader>ci', vim.lsp.buf.implementation, bufopts) -- 'i' -> implementation
        vim.keymap.set('n', '<Leader>cl', vim.lsp.buf.references, bufopts) -- 'l' -> list
        vim.keymap.set('n', '<Leader>cr', vim.lsp.buf.rename, bufopts)
        vim.keymap.set({'n', 'i'}, '<C-s>', vim.lsp.buf.signature_help, bufopts) -- 's' -> signature

        vim.api.nvim_create_user_command('DiagList', ignore_args_wrapper(vim.diagnostic.setloclist), {})
        vim.api.nvim_create_user_command('DiagEnable', function() vim.diagnostic.enable(true) end, {})
        vim.api.nvim_create_user_command('DiagDisable', function() vim.diagnostic.enable(false) end, {})

        if client.server_capabilities.documentHighlightProvider then
            -- number of milliseconds needed for highlight to appear
            vim.opt.updatetime = 250

            local lsp_highlight_group = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = false })
            vim.api.nvim_clear_autocmds { buffer = bufnr, group = 'lsp_document_highlight' }
            vim.api.nvim_create_autocmd('CursorHold', {
                callback = vim.lsp.buf.document_highlight,
                buffer = bufnr,
                group = lsp_highlight_group,
                desc = 'Document highlight',
            })
            vim.api.nvim_create_autocmd('CursorHoldI', {
                callback = vim.lsp.buf.document_highlight,
                buffer = bufnr,
                group = lsp_highlight_group,
                desc = 'Document highlight',
            })
            vim.api.nvim_create_autocmd('CursorMoved', {
                callback = vim.lsp.buf.clear_references,
                buffer = bufnr,
                group = lsp_highlight_group,
                desc = 'Clear all the references',
            })
        end

        if client.server_capabilities.documentFormattingProvider then
            local lsp_format_group = vim.api.nvim_create_augroup('lsp_format', { clear = false })
            vim.api.nvim_clear_autocmds { buffer = bufnr, group = 'lsp_format' }
            vim.api.nvim_create_autocmd('BufWritePre', {
                -- I don't know why is it needed to wrap the callback but it is what it is
                callback = ignore_args_wrapper(vim.lsp.buf.format),
                buffer = bufnr,
                group = lsp_format_group,
                desc = 'Format document on write'
            })
        end
    end

    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp_user_config', {}),
        callback = on_lsp_attach
    })

    local lspconfig = require('lspconfig')

    lspconfig.clangd.setup {
        cmd = { 'clangd', '--fallback-style=none' },
        on_attach = function(client, bufnr)
            vim.keymap.set('n', '<Leader>cs', ':ClangdSwitchSourceHeader<CR>', bufopts) -- 's' -> switch
        end
    }

    lspconfig.pyright.setup {}
    lspconfig.rust_analyzer.setup {}
    lspconfig.lua_ls.setup {
        on_init = function(client)
            local path = client.workspace_folders[1].name
            if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                return
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                    -- Tell the language server which version of Lua you're using
                    -- (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT'
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME
                        -- Depending on the usage, you might want to add additional paths here.
                        -- "${3rd}/luv/library"
                        -- "${3rd}/busted/library",
                    }
                    -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                    -- library = vim.api.nvim_get_runtime_file("", true)
                }
            })
        end,
        settings = {
            Lua = {
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = {
                        'vim',
                    }
                }
            }
        }
    }
end

return {
    'neovim/nvim-lspconfig',
    config = cfg
}
