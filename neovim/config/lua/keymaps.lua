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

-- copy `<filename>:<start_line>-<end_line>` for visual selection
vim.keymap.set(
    'v',
    '<Leader>yp',
    function()
        local path = vim.fn.expand('%:.')
        local start_line = vim.fn.line('v')
        local end_line = vim.fn.line('.')
        if start_line > end_line then
            start_line, end_line = end_line, start_line
        end
        vim.fn.setreg('+', path .. ':' .. start_line .. '-' .. end_line)
    end,
    opts
)

-- unmap the default behavior of `gr` so that it wouldn't clash with the default lsp mappings
vim.keymap.set('n', 'gr', '', opts)
