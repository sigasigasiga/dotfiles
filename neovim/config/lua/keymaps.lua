-- MARK: shortcuts
local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
local normal_mode = 'n'

-- MARK: actual keymap configs

-- copy `<filename>:<line_number>`
-- FIXME: remove duplicate keymaps
keymap(normal_mode, 'yp', ':let @+=expand("%") . ":" . line(".")<CR>', opts)
keymap(normal_mode, 'yP', ':let @+=expand("%") . ":" . line(".")<CR>', opts)

-- unmap the default behavior of `gr` so that it wouldn't clash with the default lsp mappings
keymap(normal_mode, 'gr', '', opts)

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
