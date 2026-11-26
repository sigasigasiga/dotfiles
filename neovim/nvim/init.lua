require 'vim._core.ui2'.enable()

local options = {
    -- numbers on the left
    number = true,
    -- show N lines above/below the cursor
    scrolloff = 5,
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

-- fuzzy search is awesome. menuone allows to see the docs for the only option available
vim.opt.completeopt:append('menuone,fuzzy')

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

-- leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- opens current buffer as a terminal buffer
-- useful for log files that contain ANSI terminal sequences
-- see `:h nvim_open_term` for more info
vim.api.nvim_create_user_command(
    'TermHl',
    function() vim.api.nvim_open_term(0, {}) end,
    { desc = 'Highlights ANSI termcodes in curbuf' }
)

-- Go to the command mode and then return back to the terminal
vim.keymap.set('t', [[<C-\>:]], [[<C-\><C-o>:]])
vim.keymap.set('t', [[<C-\>;]], [[<C-\><C-o>:]])
