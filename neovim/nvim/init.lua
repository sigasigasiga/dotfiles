require 'vim._core.ui2'.enable()

local options = {
    -- numbers on the left
    number = true,
    -- show N lines above/below the cursor
    scrolloff = 5,
    -- autocompletions in insert mode options
    completeopt = 'menu,menuone,popup,fuzzy',
    -- long lines will be wrapped onto the next line
    linebreak = true,
    -- search
    showmatch = true,
    -- add russian layout. use <C-6> to switch between layouts
    keymap = 'russian-jcukenwin',
    -- do not fold file by default
    foldenable = false,
    -- show trailing whitespaces and tab characters
    list = true,
    -- it behaves exactly like the default statusline,
    -- except the visual character number (`%V`) is removed
    statusline = '%<%f %h%m%r%=%-14.(%l,%c%) %P',
    -- show `:%s` substitution results in all buffer
    inccommand = 'split',
    -- enable project-specific configs. these are safe, see `:h trust`
    exrc = true,
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

-- schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

-- when `keymap` is set, `iminsert` and `imsearch` are fucked up, so we need to fix them
-- however, we cannot do that using `options` table because the iteration order of `pairs()` is unspecified
vim.opt.iminsert = 0
vim.opt.imsearch = 0

-- for some reason 'en_US' is not present on all systems (e.g. on raspberry pi), don't error out on that
pcall(vim.cmd.language, 'en_US')

-- angle brackets matching behaviour
vim.opt.matchpairs:append('<:>')

-- fuzzy finder (use with `:find`)
vim.opt.path:append('**')

-- clear search results
vim.api.nvim_create_user_command('CS', 'let @/ = ""', {})

-- external tools
vim.api.nvim_create_user_command(
    'JqReformatCurBuf',
    function()
        assert(vim.fn.executable 'jq' == 1)
        vim.cmd('%!jq .')
    end,
    {}
)

-- diagnostics
vim.diagnostic.config({ virtual_text = true })
vim.api.nvim_create_user_command('DiagList', function() vim.diagnostic.setloclist() end, {})
vim.api.nvim_create_user_command('DiagEnable', function() vim.diagnostic.enable(true) end, {})
vim.api.nvim_create_user_command('DiagDisable', function() vim.diagnostic.enable(false) end, {})

-- netrw config
--[[
TODO: uncomment whenever https://github.com/neovim/neovim/issues/23650 is fixed
vim.g.netrw_banner = 0                   -- hide help banner on the top (can be shown with `I`)
vim.g.netrw_list_hide = [[^\./$,^\../$]] -- hide `.` from directory list
--]]
vim.g.netrw_sort_sequence = '[\\/]$'     -- dirs are shown on the top

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

-- leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

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

-- codestyles
local codestyles = {
    drw = {
        -- tab settings (expandtab changes tabs to spaces)
        tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = true,
        -- autoindent settings. cinoptions are fucky, so tldr:
        -- `l1` = don't fuck up curly braces in `case`
        -- `g0` = access modifiers are not indented
        -- `N-s` = namespaces are not indented
        -- `(0,W4` = `void foo(<CR> /* next line is 4 space indented`
        -- `(s,m1` = `void foo(<CR>` will have `)` on beginning of the next line
        -- `j1` = don't fuck up lambda definitions in an argument list
        -- `J1` = don't fuck up JS (and cpp2!) object declarations
        ai = true, cin = true, cinoptions = 'l1,g0,N-s,(0,W4,(s,m1,j1,J1',
    },

    gnu = {
        tabstop = 8, shiftwidth = 2, softtabstop = 2, expandtab = false,
        ai = true, cin = true, cinoptions='>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1',
    }
}

local set_codestyle = function(style)
    for k, v in pairs(style) do
        vim.opt[k] = v
    end
end

-- set default codestyle
set_codestyle(codestyles.drw)

-- set codestyle with ease
vim.api.nvim_create_user_command(
    'SetCodestyle',
    function(params) set_codestyle(codestyles[params.args]) end,
    { nargs = 1 }
)
