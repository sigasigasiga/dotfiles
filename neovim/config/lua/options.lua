local options = {
    -- numbers on the left
    number = true,
    -- show N lines above/below the cursor
    scrolloff = 5,
    -- autocompletions in command mode
    wildmenu = true,
    wildmode = { 'list', 'longest', 'full' },
    -- long lines will be wrapped onto the next line
    linebreak = true,
    wrap = true,
    -- search
    showmatch = true,
    hlsearch = true,
    incsearch = true,
    -- add russian layout. use <C-6> to switch between layouts
    keymap = 'russian-jcukenwin',
    -- mouse
    mouse = 'a',
    -- undo will work even after nvim restarts
    undofile = true,
    -- do not fold file by default
    foldenable = false,
    -- enable syntax
    syntax = 'on',
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
vim.g.netrw_altv = 1 -- open vertical splits on the right
vim.g.netrw_alto = 1 -- open horizontal splits on the bottom

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
