vim.pack.add {
    'https://github.com/sigasigasiga/gruvbox.nvim',
    { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' }
}


local gruvbox_gray = '#504945'

require 'gruvbox'.setup {
    contrast = 'hard',
    overrides = {
        LspReferenceRead = { bg = gruvbox_gray },
        LspReferenceText = { bg = gruvbox_gray },
        LspReferenceWrite = { bg = gruvbox_gray },
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
