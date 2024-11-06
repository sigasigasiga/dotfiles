local wrap_telescope_fn = function(fn)
    return function()
        require('telescope.builtin')[fn]()
    end
end

return {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    keys = {
        { '<Leader>fg', wrap_telescope_fn('git_files'), mode = 'n' }
    },
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
}
