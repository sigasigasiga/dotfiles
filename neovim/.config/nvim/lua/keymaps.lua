-- MARK: shortcuts
local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
local normal_mode = 'n'

-- MARK: actual keymap configs

-- copy `+<line number> <filename>`
keymap(normal_mode, 'yp', ':let @+="+" . line(".") . " " . expand("%")<CR>', opts)
-- copy `<filename>:<line_number>`
keymap(normal_mode, 'yP', ':let @+=expand("%") . ":" . line(".")<CR>', opts)
