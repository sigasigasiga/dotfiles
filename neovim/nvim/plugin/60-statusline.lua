local function current_git_object()
    local fugitive_statusline = vim.g.loaded_fugitive and vim.fn.FugitiveStatusline() or ''

    if fugitive_statusline == '' then
        return ''
    end

    -- The string is of form `[Git<...>]` and we want to remove the brackets and the `Git` prefix
    local git_object = string.sub(fugitive_statusline, 5, -2)

    return git_object
end

local expr_builder = {}

function expr_builder:new(str)
    local ret = { v = str }
    setmetatable(ret, self)
    self.__index = self
    return ret
end

function expr_builder:trunc(width)
    local cur_width = vim.o.laststatus == 3 and vim.o.columns or vim.api.nvim_win_get_width(0)
    local is_truncated = cur_width < (width or -1)

    if is_truncated then
        self.v = ''
    end

    return self
end

function expr_builder:hl(hl_name)
    if self.v ~= '' then
        self.v = table.concat { '%#', hl_name, '#', self.v, '%*' }
    end

    return self
end

function expr_builder:append_ws()
    if self.v ~= '' then
        self.v = self.v .. ' '
    end

    return self
end

function expr_builder:build()
    return self.v
end

function SigaStatusline()
    local git_expr = expr_builder:new(current_git_object())
            :trunc(40)
            :hl('MiniStatuslineModeVisual')
            :append_ws()
            :build()

    return table.concat {
        git_expr,
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
