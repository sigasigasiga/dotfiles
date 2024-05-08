return function()
    -- unfortunately, `packer.nvim` doesn't support upvalues in config functions
    -- TODO: try `lazy.nvim`
    local ignore_args_wrapper = function(f)
        return function()
            f()
        end
    end

    local on_lsp_attach = function(event)
        local bufnr = event.buf
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- Enable completion triggered by <c-x><c-o>
        vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local bufopts = { noremap=true, silent=true }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', 'gl', vim.lsp.buf.references, bufopts)

        -- 'l' stands for 'lsp'
        vim.keymap.set({'n', 'v'}, '<Leader>lh', vim.lsp.buf.hover, bufopts)

        vim.api.nvim_create_user_command('DiagList', ignore_args_wrapper(vim.diagnostic.setloclist), {})
        vim.api.nvim_create_user_command('DiagEnable', ignore_args_wrapper(vim.diagnostic.enable), {})
        vim.api.nvim_create_user_command('DiagDisable', ignore_args_wrapper(vim.diagnostic.disable), {})

        if client.server_capabilities.documentHighlightProvider then
            -- number of milliseconds needed for highlight to appear
            vim.opt.updatetime = 250

            local lsp_highlight_group = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = false })
            vim.api.nvim_clear_autocmds{ buffer = bufnr, group = 'lsp_document_highlight' }
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
            vim.api.nvim_clear_autocmds{ buffer = bufnr, group = 'lsp_format' }
            vim.api.nvim_create_autocmd('BufWritePre', {
                -- I don't know why is it needed to wrap the callback but it is what it is
                callback = ignore_args_wrapper(vim.lsp.buf.format),
                buffer = bufnr,
                group = lsp_fromat_group,
                desc = 'Format document on write'
            })
        end
    end

    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp_user_config', {}),
        callback = on_lsp_attach
    })

    lspconfig = require('lspconfig')

    lspconfig.clangd.setup{
        cmd = { 'clangd', '--fallback-style=none' },
        on_attach = function(client, bufnr)
            vim.keymap.set('n', 'gc', ':ClangdSwitchSourceHeader<CR>', { noremap=true, silent=true })
        end
    }

    lspconfig.pyright.setup{}
end
