function _G.SigaCurrentGitObject()
    if not vim.g.loaded_fugitive then
        return ''
    end

    local fugitive_statusline = vim.fn.FugitiveStatusline()

    if fugitive_statusline == '' then
        return ''
    end

    -- The string is of form `[Git<...>]` and we want to remove the brackets and the `Git` prefix
    local git_object = string.sub(fugitive_statusline, 5, -2):gsub('%%', '%%%%')

    return '%#MiniStatuslineModeVisual#' .. git_object .. '%* '
end

local statusline_git_expr = '%{%v:lua.SigaCurrentGitObject()%}'

-- it behaves exactly like the default statusline, except:
-- 1. the visual character number (`%V`) is removed
-- 2. current git object is added
vim.opt.statusline = '%<' .. statusline_git_expr .. '%f %h%m%r%=%-14.(%l,%c%) %P'
