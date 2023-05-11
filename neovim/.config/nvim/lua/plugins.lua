vim.cmd([[packadd termdebug]])

return require('packer').startup(function(use)
    use {
        'wbthomason/packer.nvim'
    }

    use {
        'neovim/nvim-lspconfig',
        config = function()
            require('lspconfig').clangd.setup{
                -- TODO: set those in a separate file
                on_attach = function(client, bufnr)
                    -- enable autocompletion via <c-x><c-o>
                    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

                    local bufopts = { noremap=true, silent=true }
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
                    vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, bufopts)
                    vim.keymap.set('n', 'gl', vim.lsp.buf.references, bufopts)
                    vim.keymap.set('n', 'gc', ':ClangdSwitchSourceHeader<CR>', bufopts)

                    vim.api.nvim_create_user_command('DiagList', vim.diagnostic.setloclist, {})
                    vim.api.nvim_create_user_command('DiagEnable', vim.diagnostic.enable, {})
                    vim.api.nvim_create_user_command('DiagDisable', vim.diagnostic.disable, {})

                    if client.server_capabilities.documentHighlightProvider then
                        -- number of milliseconds needed for highlight to appear
                        vim.opt.updatetime = 250

                        vim.api.nvim_create_augroup('lsp_document_highlight', { clear = false })
                        vim.api.nvim_clear_autocmds { buffer = bufnr, group = 'lsp_document_highlight' }
                        vim.api.nvim_create_autocmd('CursorHold', {
                            callback = vim.lsp.buf.document_highlight,
                            buffer = bufnr,
                            group = 'lsp_document_highlight',
                            desc = 'Document Highlight',
                        })
                        vim.api.nvim_create_autocmd('CursorHoldI', {
                            callback = vim.lsp.buf.document_highlight,
                            buffer = bufnr,
                            group = 'lsp_document_highlight',
                            desc = 'Document Highlight',
                        })
                        vim.api.nvim_create_autocmd('CursorMoved', {
                            callback = vim.lsp.buf.clear_references,
                            buffer = bufnr,
                            group = 'lsp_document_highlight',
                            desc = 'Clear All the References',
                        })
                    end
                end
            }
        end
    }

    use {
        'ellisonleao/gruvbox.nvim',
        config = function()
            local gray = '#504945'

            require('gruvbox').setup({
                overrides = {
                    LspReferenceRead = {bg = gray},
                    LspReferenceText = {bg = gray},
                    LspReferenceWrite = {bg = gray},
                }
            })

            vim.o.background = 'dark'
            vim.cmd.colorscheme('gruvbox')
        end
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
        cmd = { 'Git' }
    }

    use {
        'lambdalisue/suda.vim'
    }

    use {
        'nvim-tree/nvim-tree.lua',
        config = function()
            require('nvim-tree').setup()
            -- TODO: set keymaps in a separate config file
            vim.api.nvim_set_keymap('n', '\\nt', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '\\nf', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })
        end
    }
end)
