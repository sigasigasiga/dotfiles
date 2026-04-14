vim.api.nvim_create_autocmd('PackChanged', { callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'telescope-fzf-native.nvim' and (kind == 'install' or kind == 'update') then
        local plugin_dir = vim.fn.stdpath('data') .. '/site/pack/core/opt/' .. name
        if vim.fn.executable 'make' == 1 then
            vim.system({ 'make' }, { cwd = plugin_dir })
        elseif vim.fn.executable 'cmake' == 1 then
            vim.system(
                { 'cmake', '-S.', '-Bbuild', '-DCMAKE_BUILD_TYPE=Release' },
                { cwd = plugin_dir },
                function()
                    vim.system({ 'cmake', '--build', 'build', '--config', 'Release' }, { cwd = plugin_dir })
                end
            )
        end
    end
end })

vim.pack.add {
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
    'https://github.com/nvim-telescope/telescope.nvim',
}

-- if we were unable to build fzf that doesn't mean
-- we should error out, the plugin is still usable
pcall(function() require('telescope').load_extension('fzf') end)

local wrap_telescope_fn = function(fn, params)
    return function()
        require('telescope.builtin')[fn](params)
    end
end

local grep_args = {
    additional_args = { '-S' }
}

vim.keymap.set('n', '<Leader>fo',  wrap_telescope_fn('oldfiles'))             -- 'o' -> '^O'/old

-- plz install ripgrep for these
vim.keymap.set('n', '<Leader>ff',  wrap_telescope_fn('find_files'))           -- 'f' -> 'files'
vim.keymap.set('n', '<Leader>fs',  wrap_telescope_fn('live_grep', grep_args)) -- 's' -> 'string'

-- 'g' -> 'git'
vim.keymap.set('n', '<Leader>fgf', wrap_telescope_fn('git_files'))            -- 'f' -> 'files'
vim.keymap.set('n', '<Leader>fgs', wrap_telescope_fn('git_status'))           -- 's' -> 'status'

-- 'c' -> 'code'
vim.keymap.set('n', '<Leader>fcs', wrap_telescope_fn('lsp_document_symbols'))
