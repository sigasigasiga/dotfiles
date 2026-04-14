vim.pack.add {
    'https://github.com/ellisonleao/gruvbox.nvim',
    { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
}

local gruvbox_gray = '#504945'
require('gruvbox').setup {
    contrast = 'hard',
    overrides = {
        LspReferenceRead = { bg = gruvbox_gray },
        LspReferenceText = { bg = gruvbox_gray },
        LspReferenceWrite = { bg = gruvbox_gray },
    }
}
