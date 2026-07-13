vim.pack.add {
    'https://github.com/sigasigasiga/gruvbox.nvim',
    { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' }
}


local gruvbox = require 'gruvbox'

gruvbox.setup {
    contrast = 'hard',
    overrides = {
        LspReferenceRead = { bg = gruvbox.palette.dark2 },
        LspReferenceText = { bg = gruvbox.palette.dark2 },
        LspReferenceWrite = { bg = gruvbox.palette.dark2 },
        CursorLine = { bg = gruvbox.palette.dark0_soft },
    },
}

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

set_colorscheme()

vim.api.nvim_create_autocmd('OptionSet', {
    pattern = 'background',
    callback = function(ev)
        set_colorscheme()
    end
})
