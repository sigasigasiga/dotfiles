local make_gruvbox_opts = function()
    local gruvbox_gray = '#504945'

    return {
        contrast = 'hard',
        overrides = {
            LspReferenceRead = { bg = gruvbox_gray },
            LspReferenceText = { bg = gruvbox_gray },
            LspReferenceWrite = { bg = gruvbox_gray },
        }
    }
end

return {
    {
        'ellisonleao/gruvbox.nvim',
        opts = make_gruvbox_opts(),
        priority = 1000,
    },

    {
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 1000,
    }
}
