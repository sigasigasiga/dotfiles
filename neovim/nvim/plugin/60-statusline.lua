function SigaCurrentGitObject()
    local fugitive_statusline = vim.g.loaded_fugitive and vim.fn.FugitiveStatusline() or ''

    if fugitive_statusline == '' then
        return ''
    end

    -- The string is of form `[Git<...>]` and we want to remove the brackets and the `Git` prefix
    local git_object = string.sub(fugitive_statusline, 5, -2)

    return git_object
end

local function hl_expr(hl, val)
    return table.concat { '%#', hl, '#', val, '%*' }
end

local function trunc_expr(trunc_width, expr)
    local cur_width = vim.o.laststatus == 3 and vim.o.columns or vim.api.nvim_win_get_width(0)
    local is_truncated = cur_width < (trunc_width or -1)

    if is_truncated then
        return ''
    else
        return expr
    end
end

function SigaStatusline()
    return table.concat {
        trunc_expr(40, hl_expr('MiniStatuslineModeVisual', '%{v:lua.SigaCurrentGitObject()}')),
        trunc_expr(40, ' '),
        '%f', -- relative path
        '%<', -- Where to truncate line if too long
        ' ',
        '%h', -- `[Help]`
        '%m', -- modified flag (`[+]`/`[-]`)
        '%r', -- readonly flag (`[RO]`)

        '%=', -- align the rest to the right
        '%-14.(', -- left justify the contents 14 characters
            '%l', -- line number
            ',',
            '%c', -- character number
        '%)',
        ' ',
        '%P', -- percentage through the file of displayed window
    }
end

-- while it is possible to just insert the return value of `SigaStatusline` directly,
-- wrapping it with `%{%%}` lets us generate it on the fly.
-- this way we can dynamically decide what to print
vim.opt.statusline = '%{%v:lua.SigaStatusline()%}'
