local gruvbox_gray = '#504945'

return {
    {
        'ellisonleao/gruvbox.nvim',
        lazy = false,
        opts = {
            overrides = {
                LspReferenceRead = { bg = gruvbox_gray },
                LspReferenceText = { bg = gruvbox_gray },
                LspReferenceWrite = { bg = gruvbox_gray },
            }
        }
    },

    'catppuccin/nvim',
}
