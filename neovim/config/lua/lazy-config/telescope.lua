local wrap_telescope_fn = function(fn, params)
    return function()
        require('telescope.builtin')[fn](params)
    end
end

local grep_args = {
    additional_args = { '-S' }
}

return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = 'Telescope',
    keys = {
        { '<Leader>fo',  wrap_telescope_fn('oldfiles'),             mode = 'n' }, -- 'o' -> '^O'/old

        -- plz install ripgrep for these
        { '<Leader>ff',  wrap_telescope_fn('find_files'),           mode = 'n' }, -- 'f' -> 'files'
        { '<Leader>fs',  wrap_telescope_fn('live_grep', grep_args), mode = 'n' }, -- 's' -> 'string'

        -- 'g' -> 'git'
        { '<Leader>fgf', wrap_telescope_fn('git_files'),            mode = 'n' }, -- 'f' -> 'files'
        { '<Leader>fgs', wrap_telescope_fn('git_status'),           mode = 'n' }, -- 's' -> 'status'


        -- 'c' -> 'code'
        { '<Leader>fcs', wrap_telescope_fn('lsp_document_symbols'), mode = 'n' },
    },
}
