vim.pack.add {
    'https://github.com/neovim/nvim-lspconfig',
}

-- unmap the default behavior of `gr` so that it wouldn't clash with the default lsp mappings
vim.keymap.set('n', 'gr', '', { noremap = true, silent = true })

vim.lsp.config('*', {})

local on_lsp_attach = function(event)
    local bufnr = event.buf

    -- Enable completion triggered by <C-x><C-o>
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local bufopts = { noremap = true, silent = true, buf = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set({'n', 'i'}, '<C-s>', vim.lsp.buf.signature_help, bufopts) -- 's' -> signature

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    assert(client)
    if client:supports_method 'textDocument/documentHighlight' then
        -- number of milliseconds needed for highlight to appear
        vim.opt.updatetime = 250

        -- `on_lsp_attach` is executed each time a new buffer is spawned.
        -- we create a new autocommand for each buffer separately,
        -- because of that we should never clear `siga/lsp/document_highlight` augroup
        local lsp_highlight_group = vim.api.nvim_create_augroup('siga/lsp/document_highlight', { clear = false })
        vim.api.nvim_create_autocmd('CursorHold', {
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

    if client:supports_method 'textDocument/switchSourceHeader' then
        vim.keymap.set('n', 'grs', vim.cmd.LspClangdSwitchSourceHeader, bufopts) -- 's' -> switch
    end
end

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('siga/lsp/server_attach', {}),
    callback = on_lsp_attach
})

vim.lsp.enable {
    'clangd',
    'lua_ls',
    'pyright',
    'rust_analyzer',
    'bashls',
    'ts_ls',
    'nixd',
}
