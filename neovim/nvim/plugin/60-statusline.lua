function _G.SigaCurrentGitObject()
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

vim.opt.statusline = table.concat {
    hl_expr('MiniStatuslineModeVisual', '%{v:lua.SigaCurrentGitObject()}'), -- TODO: truncate it out if there's not enough space
    ' ',
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
