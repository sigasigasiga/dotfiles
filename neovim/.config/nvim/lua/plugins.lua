vim.cmd([[packadd termdebug]])
require('plugins.dark_monitor')

return require('packer').startup(function(use)
    use {
        'wbthomason/packer.nvim'
    }

    use {
        'neovim/nvim-lspconfig',
        config = require('plugins.lsp')
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
        config = require('plugins.nvim-tree')
    }
end)
