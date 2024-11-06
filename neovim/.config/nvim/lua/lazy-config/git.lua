return {
    {
        'tpope/vim-fugitive',
        cmd = {
            'G', 'Git', 'Gdiffsplit', 'Gvdiffsplit', 'Gedit', 'Gsplit', 'Gread',
            'Gwrite', 'Ggrep', 'Glgrep', 'Gmove', 'Gdelete', 'Gremove', 'GBrowse',
        },
    },

    {
        'tommcdo/vim-fubitive',
        cmd = 'GBrowse',
        dependencies = {
            'tpope/vim-fugitive',
        },
    },
}
