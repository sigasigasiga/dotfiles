local options = {
    -- numbers on the left
    number = true,
    -- autocompletions in command mode
    wildmenu = true, wildmode = { 'list', 'longest', 'full' },
    -- long lines will be wrapped onto the next line
    linebreak = true, wrap = true,
    -- search
    showmatch = true, hlsearch = true, incsearch = true,
    -- russian layout settings. also sets default layout to english (last 2 opts)
    keymap = 'russian-jcukenwin', iminsert = 0, imsearch = 0,
    -- Xorg
    clipboard = 'unnamedplus', mouse = 'a',
    -- do not fold file by default
    foldenable = false,
    -- enable syntax
    syntax = 'on',
    -- show trailing whitespaces and tab characters
    list = true
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

-- FIXME: i dont know why but these settings cannot be set reliably via lua
vim.cmd[[set iminsert=0 imsearch=0]]

-- for some reason 'en_US' is not present on all systems, don't error out on that
pcall(vim.cmd.language, 'en_US')

-- angle brackets matching behaviour
vim.opt.matchpairs:append('<:>')

-- fuzzy finder (use with `:find`)
vim.opt.path:append('**')

-- clear search results
vim.api.nvim_create_user_command('CS', 'let @/ = ""', {})
