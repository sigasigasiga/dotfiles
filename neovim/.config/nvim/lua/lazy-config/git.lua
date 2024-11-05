return {
    {
        'tpope/vim-fugitive',
        lazy = true,
        cmd = {
            'G', 'Git', 'Gdiffsplit', 'Gvdiffsplit', 'Gedit', 'Gsplit', 'Gread',
            'Gwrite', 'Ggrep', 'Glgrep', 'Gmove', 'Gdelete', 'Gremove', 'GBrowse',
        },
    },

    {
        'tommcdo/vim-fubitive',
        lazy = true,
        cmd = 'GBrowse',
        dependencies = {
            'tpope/vim-fugitive',
        },
    },
}
