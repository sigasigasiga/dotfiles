vim.cmd([[packadd termdebug]])

return require('packer').startup(function(use)
    -- TODO: add packer submodule
    use {
        'wbthomason/packer.nvim'
    }

    use {
        'neovim/nvim-lspconfig',
        config = function()
            require('lspconfig').clangd.setup{
                -- TODO: set those in a separate file
                on_attach = function()
                    local bufopts = { noremap=true, silent=true }
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
                    vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, bufopts)
                    vim.keymap.set('n', 'gl', vim.lsp.buf.references, bufopts)
                    vim.keymap.set('n', 'gc', ':ClangdSwitchSourceHeader<CR>', bufopts)
                end
            }
        end
    }

    use {
        'ellisonleao/gruvbox.nvim',
        config = function()
            vim.o.background = "dark"
            vim.cmd([[colorscheme gruvbox]])
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
