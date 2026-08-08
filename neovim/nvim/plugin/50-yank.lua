-- YankRing ( https://x.com/justinmk/status/1911092038109364377 )
vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('siga/yankring', {}),
    callback = function()
        if vim.v.event.operator == 'y' then
            for i = 9, 1, -1 do
                vim.fn.setreg(tostring(i), vim.fn.getreg(tostring(i - 1)))
            end
        end
    end,
})

local keymap_opts = { noremap = true, silent = true }

-- copy `<filename>:<line_number>`
vim.keymap.set(
    'n',
    '<Leader>yp',
    function()
        local path = vim.fn.expand('%:.') -- Get _relative_ path
        local line = vim.fn.line('.')
        vim.fn.setreg('+', path .. ':' .. line)
    end,
    keymap_opts
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
    keymap_opts
)
