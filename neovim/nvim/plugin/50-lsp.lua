vim.pack.add {
    'https://github.com/neovim/nvim-lspconfig',
}

-- globally unmap the default behavior of `gr` so that it wouldn't clash with the default lsp mappings
vim.keymap.set('n', 'gr', '', { noremap = true, silent = true })

vim.lsp.config('*', {})

local function others_support(bufnr, client, method)
    local lsp_clients = vim.lsp.get_clients { bufnr = bufnr, method = method }

    return vim.iter(lsp_clients)
        :any(function(c) return c.id ~= client.id end)
end

--- Run setup/teardown callbacks when an LSP method becomes available or
--- unavailable in a buffer.
---
--- setup runs when the first client supporting the method attaches to a
--- buffer; teardown runs when the last one detaches. Assumes servers don't
--- register or unregister capabilities dynamically using `client/registerCapability`.
local function setup_lsp_handlers(handlers)
    local augroup = vim.api.nvim_create_augroup('siga/lsp/attach_handlers', { clear = true })

    vim.api.nvim_create_autocmd('LspAttach', {
        group = augroup,
        callback = function(args)
            local bufnr = args.buf

            -- workaround for https://github.com/neovim/neovim/issues/33225
            -- remove it when the issue is fixed
            if vim.api.nvim_buf_get_name(bufnr):match "^%a+://" then
                return
            end

            local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
            for _, h in ipairs(handlers) do
                if client:supports_method(h.method, bufnr) and not others_support(bufnr, client, h.method) then
                    h.setup(bufnr, client)
                end
            end
        end,
    })

    -- registered once: registering it per attach would stack duplicate handlers
    -- and run teardown multiple times after re-enabling a client
    vim.api.nvim_create_autocmd('LspDetach', {
        group = augroup,
        callback = function(args)
            local bufnr = args.buf

            if not vim.api.nvim_buf_is_valid(bufnr) then
                return
            end

            -- same workaround as in `LspAttach`: setup never ran for these buffers
            if vim.api.nvim_buf_get_name(bufnr):match "^%a+://" then
                return
            end

            local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
            for _, h in ipairs(handlers) do
                if h.teardown and client:supports_method(h.method, bufnr) and not others_support(bufnr, client, h.method) then
                    h.teardown(bufnr, client)
                end
            end
        end,
    })
end

local function make_keymap_handler(method, modes, keys, cb)
    return {
        method = method,
        setup = function(bufnr) vim.keymap.set(modes, keys, cb, { buf = bufnr }) end,
        teardown = function(bufnr) vim.keymap.del(modes, keys, { buf = bufnr }) end,
    }
end

local function make_document_highlight_handler()
    local augroup = vim.api.nvim_create_augroup('siga/lsp/documentHighlight', { clear = false })

    return {
        method = 'textDocument/documentHighlight',

        setup = function(bufnr)
            -- number of milliseconds needed for highlight to appear
            vim.opt_local.updatetime = 250

            vim.api.nvim_create_autocmd('CursorHold', {
                callback = vim.lsp.buf.document_highlight,
                buffer = bufnr,
                group = augroup,
                desc = 'Document highlight',
            })
            vim.api.nvim_create_autocmd('CursorMoved', {
                callback = vim.lsp.buf.clear_references,
                buffer = bufnr,
                group = augroup,
                desc = 'Clear all the references',
            })
        end,

        teardown = function(bufnr)
            vim.lsp.util.buf_clear_references(bufnr)
            vim.api.nvim_clear_autocmds { buffer = bufnr, group = augroup }
        end,
    }
end

setup_lsp_handlers {
    make_keymap_handler('textDocument/declaration',          'n',          'gD',      vim.lsp.buf.declaration),
    make_keymap_handler('textDocument/definition',           'n',          'gd',      vim.lsp.buf.definition),
    make_keymap_handler('textDocument/signatureHelp',        {'n', 'i'},   '<C-s>',   vim.lsp.buf.signature_help),
    make_keymap_handler('textDocument/switchSourceHeader',   'n',          'grs',     vim.cmd.LspClangdSwitchSourceHeader),

    make_document_highlight_handler(),
}

vim.lsp.enable {
    'clangd',
    'lua_ls',
    'pyright',
    'rust_analyzer',
    'bashls',
    'ts_ls',
    'nixd',
}
