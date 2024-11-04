require('rplugin-config.dark-monitor')

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
