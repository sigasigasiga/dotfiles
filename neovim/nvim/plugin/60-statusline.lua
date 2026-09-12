-- EXPR BUILDER ----------------------------------------------------------------

local expr_builder = {}

function expr_builder:new(str)
    local ret = { v = str }
    setmetatable(ret, self)
    self.__index = self
    return ret
end

function expr_builder:transform(fn)
    if self.v ~= '' then
        self.v = fn(self.v)
    end

    return self
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
    return self:transform(function(v)
        return table.concat { '%#', hl_name, '#', v, '%*' }
    end)
end

function expr_builder:append_ws()
    return self:transform(function(v)
        return v .. ' '
    end)
end

function expr_builder:fmt(fmt)
    return self:transform(function(v)
        return table.concat {
            '%',
            (fmt.left_justify and '-') or (fmt.leading_zeroes and '0') or '',
            (fmt.min_width or ''),
            '.',
            (fmt.max_width or ''),
            '(', -- introduces new item group and applies formatting to its content
            v,
            '%)', -- ends the item group
        }
    end)
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
    -- TODO: must limit the length of the branch name to something reasonable.
    -- `:fmt{ max_width = N }` won't do the job because it truncates from the left
    --
    -- see
    -- https://github.com/neovim/neovim/pull/40369
    -- https://stackoverflow.com/questions/20899651/how-to-truncate-a-vim-statusline-field-from-the-right
    local git_expr = expr_builder:new(current_git_object())
        :trunc(40)
        :hl('MiniStatuslineModeVisual')
        :append_ws()
        :build()

    local location_expr = expr_builder:new('%l,%c') -- `<line>,<column>`
        :fmt{ left_justify = true, min_width = 14 }
        :build()

    local diagnostics_expr = expr_builder:new(vim.diagnostic.status())
        :fmt{ left_justify = true, min_width = 14 }
        :build()

    return table.concat {
        git_expr,
        '%f', -- relative path
        '%<', -- Where to truncate line if too long
        ' ',
        '%h', -- `[Help]`
        '%w', -- preview window flag (`[Preview]`)
        '%m', -- modified flag (`[+]`/`[-]`)
        '%r', -- readonly flag (`[RO]`)

        '%=', -- align the rest to the right
        diagnostics_expr,
        location_expr,
        ' ',
        '%P', -- percentage through the file of displayed window
    }
end

-- while it is possible to just insert the return value of `SigaStatusline` directly,
-- wrapping it with `%{%%}` lets us generate it on the fly.
-- this way we can dynamically decide what to print
vim.opt.statusline = '%{%v:lua.SigaStatusline()%}'
