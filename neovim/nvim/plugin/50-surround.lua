vim.pack.add {
    'https://github.com/kylechui/nvim-surround',
}

require 'nvim-surround'.setup {
    surrounds = {
        ["c"] = {
            add = { "/* ", " */" },
            find = "/* %s */",
        },
    },
}
