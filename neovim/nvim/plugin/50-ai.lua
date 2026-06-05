-- This option must be set BEFORE we load the plugin, otherwise `vim.snippet.jump` will not work.
vim.g.copilot_no_tab_map = true

vim.pack.add {
    'https://github.com/github/copilot.vim',
}

vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
    expr = true,
    replace_keycodes = false
})
