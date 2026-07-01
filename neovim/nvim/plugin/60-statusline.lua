local statusline_git_expr = vim.g.loaded_fugitive and '%{FugitiveStatusline()}' or ''

-- it behaves exactly like the default statusline, except:
-- 1. the visual character number (`%V`) is removed
-- 2. the git status is added (via `FugitiveStatusline()`)
vim.opt.statusline = '%<%f %h%m%r' .. statusline_git_expr .. '%=%-14.(%l,%c%) %P'
