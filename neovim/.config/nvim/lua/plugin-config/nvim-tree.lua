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

    local bufopts = { noremap=true, silent=true }

    -- 'n' stands for 'nvim-tree' (yeah, that's stupid)
    vim.api.nvim_set_keymap('n', '<Leader>nt', ':NvimTreeToggle<CR>', bufopts)
    vim.api.nvim_set_keymap('n', '<Leader>nf', ':NvimTreeFindFile<CR>', bufopts)
end
