local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
vim.opt.rtp:prepend(lazypath)
require('lazy').setup{
    spec = {
        {
            import = 'lazy-config',
        },
    },
    local_spec = false,
}

-- TODO move it somewhere else?
local set_colorscheme = function()
    local bg = vim.opt.background:get()
    if bg == 'dark' then
        vim.cmd.colorscheme 'gruvbox'
    elseif bg == 'light' then
        vim.cmd.colorscheme 'catppuccin-latte'
    else
        assert(false, 'wtf is your background')
    end
end

vim.api.nvim_create_autocmd('OptionSet', {
    pattern = 'background',
    callback = function(ev)
        set_colorscheme()
    end
})
