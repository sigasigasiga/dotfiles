local setup_language_server = function(server_name, params)
    local lspconfig = require'lspconfig'
    local server_exec = (params.cmd or lspconfig[server_name].config_def.default_config.cmd)[1]
    if vim.fn.executable(server_exec) == 1 then
        lspconfig[server_name].setup(params)
    end
end

local on_lsp_attach = function(event)
    local bufnr = event.buf

    -- Enable completion triggered by <C-x><C-o>
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- 'c' stands for 'code'
    local bufopts = { noremap = true, silent = true }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set({'n', 'i'}, '<C-s>', vim.lsp.buf.signature_help, bufopts) -- 's' -> signature

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    assert(client)
    if client.server_capabilities.documentHighlightProvider then
        -- number of milliseconds needed for highlight to appear
        vim.opt.updatetime = 250

        local lsp_highlight_group = vim.api.nvim_create_augroup('siga/lsp/document_highlight', { clear = true })
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
        local lsp_format_group = vim.api.nvim_create_augroup('siga/lsp/autoformat', { clear = true })
        vim.api.nvim_create_autocmd('BufWritePre', {
            -- I don't know why is it needed to wrap the callback but it is what it is
            callback = function() vim.lsp.buf.format() end,
            buffer = bufnr,
            group = lsp_format_group,
            desc = 'Format document on write'
        })
    end
end


local cfg = function()
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('siga/lsp/server_attach', { clear = true }),
        callback = on_lsp_attach
    })

    setup_language_server('pyright', {})
    setup_language_server('rust_analyzer', {})

    setup_language_server('clangd', {
        cmd = { 'clangd', '--fallback-style=none' },
        on_attach = function(client, bufnr)
            vim.keymap.set('n', '<Leader>cs', ':ClangdSwitchSourceHeader<CR>', bufopts) -- 's' -> switch
        end
    })

    setup_language_server('lua_ls', {
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
    })
end

return {
    'neovim/nvim-lspconfig',
    ft = { 'c', 'cpp', 'python', 'rust', 'lua', },
    config = cfg
}
