return function()
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

    vim.api.nvim_set_keymap('n', '\\nt', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '\\nf', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })
end