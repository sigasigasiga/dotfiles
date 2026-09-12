-- EXPR BUILDER ----------------------------------------------------------------

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

function expr_builder:fmt(fmt)
    if self.v ~= '' then
        self.v = table.concat {
            '%',
            (fmt.left_justify and '-') or (fmt.leading_zeroes and '0') or '',
            (fmt.min_width or ''),
            '.',
            (fmt.max_width or ''),
            '(', -- introduces new item group and applies formatting to its content
            self.v,
            '%)', -- ends the item group
        }
    end

    return self
end

function expr_builder:build()
    return self.v
end

-- EXPR GENERATORS -------------------------------------------------------------

local function current_git_object()
    local fugitive_status = vim.g.loaded_fugitive and vim.fn.FugitiveStatusline() or ''

    if fugitive_status ~= '' then
        -- remove `[Git` and `]`
        fugitive_status = string.sub(fugitive_status, 5, -2)
    end

    return fugitive_status
end

-- STATUSLINE ------------------------------------------------------------------

function SigaStatusline()
    local git_expr = expr_builder:new(current_git_object())
        :trunc(40)
        :hl('MiniStatuslineModeVisual')
        :append_ws()
        :build()

    local location_expr = expr_builder:new('%l,%c') -- `<line>,<column>`
        :fmt{ left_justify = true, min_width = 14 }
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
        location_expr,
        ' ',
        '%P', -- percentage through the file of displayed window
    }
end

-- while it is possible to just insert the return value of `SigaStatusline` directly,
-- wrapping it with `%{%%}` lets us generate it on the fly.
-- this way we can dynamically decide what to print
vim.opt.statusline = '%{%v:lua.SigaStatusline()%}'
