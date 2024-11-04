return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local bufopts = { noremap = true, silent = true }
        local telescope = require('telescope.builtin')
        vim.keymap.set('n', '<Leader>fg', telescope.git_files, bufopts)
    end
}
