vim.cmd([[packadd termdebug]])
require('plugins.dark_monitor')

return require('packer').startup(function(use)
    use {
        'wbthomason/packer.nvim'
    }

    use {
        'neovim/nvim-lspconfig',
        config = function()
            -- TODO: set those in a separate file
            lspconfig = require('lspconfig')

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(event)
                    local bufnr = event.buf
                    local client = vim.lsp.get_client_by_id(event.data.client_id)

                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    local bufopts = { noremap=true, silent=true }
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
                    vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, bufopts)
                    vim.keymap.set('n', 'gl', vim.lsp.buf.references, bufopts)

                    local ignore_args_wrapper = function(f)
                        return function()
                            f()
                        end
                    end

                    vim.api.nvim_create_user_command('DiagList', ignore_args_wrapper(vim.diagnostic.setloclist), {})
                    vim.api.nvim_create_user_command('DiagEnable', ignore_args_wrapper(vim.diagnostic.enable), {})
                    vim.api.nvim_create_user_command('DiagDisable', ignore_args_wrapper(vim.diagnostic.disable), {})

                    if client.server_capabilities.documentHighlightProvider then
                        -- number of milliseconds needed for highlight to appear
                        vim.opt.updatetime = 250

                        vim.api.nvim_create_augroup('lsp_document_highlight', { clear = false })
                        vim.api.nvim_clear_autocmds { buffer = bufnr, group = 'lsp_document_highlight' }
                        vim.api.nvim_create_autocmd('CursorHold', {
                            callback = vim.lsp.buf.document_highlight,
                            buffer = bufnr,
                            group = 'lsp_document_highlight',
                            desc = 'Document highlight',
                        })
                        vim.api.nvim_create_autocmd('CursorHoldI', {
                            callback = vim.lsp.buf.document_highlight,
                            buffer = bufnr,
                            group = 'lsp_document_highlight',
                            desc = 'Document highlight',
                        })
                        vim.api.nvim_create_autocmd('CursorMoved', {
                            callback = vim.lsp.buf.clear_references,
                            buffer = bufnr,
                            group = 'lsp_document_highlight',
                            desc = 'Clear all the references',
                        })
                    end

                    if client.server_capabilities.documentFormattingProvider then
                        vim.api.nvim_create_augroup('lsp_format', { clear = false })
                        vim.api.nvim_clear_autocmds{ buffer = bufnr, group = 'lsp_format' }
                        vim.api.nvim_create_autocmd('BufWritePre', {
                            -- I don't know why is it needed to wrap the callback but it is what it is
                            callback = function() vim.lsp.buf.format() end,
                            buffer = bufnr,
                            group = 'lsp_format',
                            desc = 'Format document on write'
                        })
                    end
                end,
            })

            lspconfig.clangd.setup{
                cmd = { 'clangd', '--fallback-style=none' },
                on_attach = function(client, bufnr)
                    vim.keymap.set('n', 'gc', ':ClangdSwitchSourceHeader<CR>', { noremap=true, silent=true })
                end
            }

            lspconfig.pyright.setup{}
        end
    }

    use {
        'ellisonleao/gruvbox.nvim',
        config = function()
            local gray = '#504945'

            require('gruvbox').setup{
                overrides = {
                    LspReferenceRead = {bg = gray},
                    LspReferenceText = {bg = gray},
                    LspReferenceWrite = {bg = gray},
                }
            }

            vim.o.background = 'dark'
        end
    }

    use {
        'EdenEast/nightfox.nvim'
    }

    use {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup()
        end
    }

    use {
        'aserowy/tmux.nvim',
        config = function()
            require('tmux').setup()
        end
    }

    use {
        'kylechui/nvim-surround',
        config = function()
            require('nvim-surround').setup()
        end
    }

    use {
        'tpope/vim-fugitive',
        opt = true,
        cmd = {
            "G", "Git", "Gdiffsplit", "Gvdiffsplit", "Gedit", "Gsplit", "Gread",
            "Gwrite", "Ggrep", "Glgrep", "Gmove", "Gdelete", "Gremove", "Gbrowse",
        }
    }

    use {
        'lambdalisue/suda.vim'
    }

    use {
        'nvim-tree/nvim-tree.lua',
        config = function()
            require('nvim-tree').setup{
                renderer = {
                    icons = {
                        show = {
                            file = false,
                            folder = false,
                            folder_arrow = false,
                            git = false
                        }
                    }
                }
            }

            -- TODO: set keymaps in a separate config file
            vim.api.nvim_set_keymap('n', '\\nt', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '\\nf', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })
        end
    }
end)
