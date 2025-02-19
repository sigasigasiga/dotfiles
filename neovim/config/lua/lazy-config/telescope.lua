local wrap_telescope_fn = function(fn, params)
    return function()
        require('telescope.builtin')[fn](params)
    end
end

local make_fzf_build_commands = function()
    if vim.fn.executable 'make' == 1 then
        return 'make'
    elseif vim.fn.executable 'cmake' == 1 then
        return { 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release', 'cmake --build build --config Release' }
    else
        return nil
    end
end

local grep_args = {
    additional_args = { '-S' }
}

return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = make_fzf_build_commands(),
        }
    },
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
    config = function()
        -- if we were unable to build fzf that doesn't mean
        -- we should error out, the plugin is still usable
        pcall(function() require 'telescope'.load_extension('fzf') end)
    end
}
