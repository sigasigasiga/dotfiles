local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
vim.opt.rtp:prepend(lazypath)
require('lazy').setup{
    spec = {
        {
            import = 'lazy-config',
        },
    },
    local_spec = false,
    performance = {
        rtp = {
            disabled_plugins = {
                'gzip',
                'man',
                'spellfile',
                'tarPlugin',
                'tohtml',
                'tutor',
                'zipPlugin',
            },
        },
    },
}

vim.lsp.config('*', {})

vim.lsp.config('clangd', {
    cmd = { 'clangd', '--fallback-style=none' },
})

vim.lsp.config('lua_ls', {
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

local on_lsp_attach = function(event)
    local bufnr = event.buf

    -- Enable completion triggered by <C-x><C-o>
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- FIXME: should we set the keybindings only once?
    local bufopts = { noremap = true, silent = true }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set({'n', 'i'}, '<C-s>', vim.lsp.buf.signature_help, bufopts) -- 's' -> signature

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    assert(client)
    if client.server_capabilities.documentHighlightProvider then
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

    if client:supports_method 'textDocument/switchSourceHeader' then
        vim.keymap.set('n', 'grs', vim.cmd.LspClangdSwitchSourceHeader, bufopts) -- 's' -> switch
    end
end

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('siga/lsp/server_attach', {}),
    callback = on_lsp_attach
})

local lsp_servers = {
    'clangd',
    'lua_ls',
    'pyright',
    'rust_analyzer',
}

for _, server_name in ipairs(lsp_servers) do
    local server_exec = vim.lsp.config[server_name].cmd[1]
    if vim.fn.executable(server_exec) == 1 then
        vim.lsp.enable(server_name)
    end
end

-- TODO move it somewhere else?
local set_colorscheme = function()
    local bg = vim.opt.background:get()
    if bg == 'dark' then
        vim.cmd.colorscheme 'gruvbox'
    elseif bg == 'light' then
        vim.cmd.colorscheme 'catppuccin-latte'
    else
        assert(false, 'wtf is your background')
    end
end

vim.api.nvim_create_autocmd('OptionSet', {
    pattern = 'background',
    callback = function(ev)
        set_colorscheme()
    end
})
