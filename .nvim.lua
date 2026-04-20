-- `.nvim.lua` is loaded after `${CFG}/init.lua` but before `${CFG}/plugin/**/*.{vim,lua}`.
-- Because plugins may override the settings that we want to set in this file,
-- we must set them only after all plugins have been loaded, thus `VimEnter` event is used.
vim.api.nvim_create_autocmd('VimEnter', {
    once = true,
    callback = function()
        vim.lsp.config('lua_ls', {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = {
                            'vim',
                        }
                    },
                    runtime = {
                        version = 'LuaJIT'
                    },
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME
                        }
                    }
                }
            }
        })
    end
})
