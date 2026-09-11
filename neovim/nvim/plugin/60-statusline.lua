vim.pack.add {
    'https://github.com/nvim-mini/mini.statusline'
}

local function fugitive_object()
    if not vim.g.loaded_fugitive then
        return ''
    end

    local fugitive_statusline = vim.fn.FugitiveStatusline()

    if fugitive_statusline == '' then
        return ''
    end

    -- The string is of form `[Git<...>]` and we want to remove the brackets and the `Git` prefix.
    -- The result is escaped because the statusline is evaluated again after `%{%...%}` expansion
    local object = string.sub(fugitive_statusline, 5, -2):gsub('%%', '%%%%')

    return object
end

-- A replacement for `MiniStatusline.section_git()` that uses `fugitive.vim`
-- instead of `mini.git` or `gitsigns.nvim`
local function section_git(args)
    if MiniStatusline.is_truncated(args.trunc_width) then
        return ''
    end

    local object = fugitive_object()

    if object == '' then
        return ''
    end

    return (args.icon or 'Git') .. ' ' .. object
end

local function statusline()
    local git           = section_git { trunc_width = 40 }
    local diagnostics   = MiniStatusline.section_diagnostics { trunc_width = 75 }
    local filename      = MiniStatusline.section_filename { trunc_width = 140 }
    local location      = '%-14.(%l,%c%) %P'

    return MiniStatusline.combine_groups {
        { hl = 'MiniStatuslineDevinfo',  strings = { git, diagnostics } },

        '%<', -- Mark general truncate point
        { hl = 'MiniStatuslineFilename', strings = { filename } },

        '%=', -- End left alignment
        { hl = mode_hl,                  strings = { location } },
    }
end


require 'mini.statusline'.setup {
  content = {
    active = statusline,
    inactive = statusline,
  },

  use_icons = false,
}


--vim.opt.statusline = '%<%f %h%m%r%=%-14.(%l,%c%) %P'
