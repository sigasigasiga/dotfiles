-- leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opts = { noremap = true, silent = true }

-- copy `<filename>:<line_number>`
vim.keymap.set(
    'n',
    '<Leader>yp',
    function()
        local path = vim.fn.expand('%:.') -- Get _relative_ path
        local line = vim.fn.line('.')
        vim.fn.setreg('+', path .. ':' .. line)
    end,
    opts
)

-- unmap the default behavior of `gr` so that it wouldn't clash with the default lsp mappings
vim.keymap.set('n', 'gr', '', opts)
