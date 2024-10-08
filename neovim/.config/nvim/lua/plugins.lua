vim.cmd([[packadd termdebug]])
require('plugin-config.dark_monitor')

return require('packer').startup(function(use)
    use {
        'wbthomason/packer.nvim'
    }

    use {
        'neovim/nvim-lspconfig',
        config = require('plugin-config.nvim-lspconfig')
    }

    use {
        'sigasigasiga/nvim-dap',
        config = require('plugin-config.nvim-dap')
    }

    use {
        'stevearc/overseer.nvim',
        config = function() require('overseer').setup() end
    }

    use {
        'ellisonleao/gruvbox.nvim',
        config = function()
            local gray = '#504945'

            require('gruvbox').setup {
                overrides = {
                    LspReferenceRead = { bg = gray },
                    LspReferenceText = { bg = gray },
                    LspReferenceWrite = { bg = gray },
                }
            }
        end
    }

    use {
        'catppuccin/nvim'
    }

    use {
        'windwp/nvim-autopairs',
        config = require('plugin-config.nvim-autopairs')
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
            "Gwrite", "Ggrep", "Glgrep", "Gmove", "Gdelete", "Gremove", "GBrowse",
        }
    }

    use {
        'tommcdo/vim-fubitive'
    }

    use {
        'lambdalisue/suda.vim'
    }

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.6',
        requires = { { 'nvim-lua/plenary.nvim' } },
        config = function()
            local bufopts = { noremap = true, silent = true }
            local telescope = require('telescope.builtin')
            vim.keymap.set('n', '<Leader>fg', telescope.git_files, bufopts)
        end
    }

    use {
        'kevinhwang91/nvim-bqf'
    }
end)
