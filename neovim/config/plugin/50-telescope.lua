vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == 'telescope-fzf-native.nvim' and (kind == 'install' or kind == 'update') then
            local opts = {
                cwd = vim.fn.stdpath('data') .. '/site/pack/core/opt/' .. name
            }

            vim.print 'Building telescope-fzf-native.nvim...'

            -- FIXME: it doesnt work :(
            if vim.fn.executable 'make' == 1 then
                vim.system({ 'make' }, opts):wait()
            elseif vim.fn.executable 'cmake' == 1 then
                -- because `make` is not available we surely need to try ninja instead
                vim.system({ 'cmake -S. -GNinja -Bbuild -DCMAKE_BUILD_TYPE=Release' }, opts):wait()
                vim.system({ 'cmake --build build --config Release' }, opts):wait()
            end
        end
    end
})

vim.pack.add {
    { src = 'https://github.com/nvim-telescope/telescope.nvim', version = 'v0.2.2' },

    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
}

local telescope = require 'telescope'

-- if we were unable to build fzf that doesn't mean
-- we should error out, the plugin is still usable
pcall(function() telescope.load_extension('fzf') end)

local grep_args = {
    additional_args = { '-S' }
}

local wrap_telescope_fn = function(fn, params)
    return function()
        require('telescope.builtin')[fn](params)
    end
end

vim.keymap.set('n', '<Leader>fo',  wrap_telescope_fn('oldfiles'))             -- 'o' -> '^O'/old
vim.keymap.set('n', '<Leader>ff',  wrap_telescope_fn('find_files'))           -- 'f' -> 'files'
vim.keymap.set('n', '<Leader>fs',  wrap_telescope_fn('live_grep', grep_args)) -- 's' -> 'string'

-- 'g' -> 'git'
vim.keymap.set('n', '<Leader>fgf', wrap_telescope_fn('git_files'))            -- 'f' -> 'files'
vim.keymap.set('n', '<Leader>fgs', wrap_telescope_fn('git_status'))           -- 's' -> 'status'

-- 'c' -> 'code'
vim.keymap.set('n', '<Leader>fcs', wrap_telescope_fn('lsp_document_symbols'))
