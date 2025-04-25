return {
    {
        'tpope/vim-fugitive',
        cmd = {
            'G', 'Git', 'Gdiffsplit', 'Gvdiffsplit', 'Gedit', 'Gsplit', 'Gread',
            'Gwrite', 'Ggrep', 'Glgrep', 'Gmove', 'Gdelete', 'Gremove', 'GBrowse',
        },
        dependencies = {
            'tpope/vim-rhubarb',
            'shumphrey/fugitive-gitlab.vim',
        }
    },
}
