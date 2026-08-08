vim.pack.add {
    { src = 'https://github.com/nvim-telescope/telescope.nvim', version = 'v0.2.2' },

    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
}

local function build_telescope_fzf_native(path)
    local opts = {
        cwd = path
    }

    local build_fn
    if vim.fn.executable 'make' == 1 then
        vim.notify('Building telescope-fzf-native.nvim with Make...', vim.log.levels.INFO)
        build_fn = function()
            return vim.system({ 'make' }, opts):wait().code == 0
        end
    elseif vim.fn.executable 'cmake' == 1 then
        vim.notify('Building telescope-fzf-native.nvim with CMake...', vim.log.levels.INFO)
        build_fn = function()
            return
                vim.system({ 'cmake', '-S.', '-GNinja', '-Bbuild', '-DCMAKE_BUILD_TYPE=Release' }, opts):wait().code == 0 and
                vim.system({ 'cmake', '--build', 'build', '--config', 'Release' }, opts):wait().code == 0
        end
    end

    if not build_fn then
        vim.notify('No build tools available, skipping telescope-fzf-native.nvim build', vim.log.levels.INFO)
    elseif build_fn() then
        vim.notify('telescope-fzf-native.nvim was built successfully', vim.log.levels.INFO)
    else
        vim.notify('Could not build telescope-fzf-native.nvim', vim.log.levels.ERROR)
    end
end

-- build the native library if it's missing, regardless of whether the plugin
-- was just installed/updated or already present on disk.
--
-- `PackChanged` would not work if the plugin is installed from the lockfile (it always is)
-- from `:h PackChanged`:
-- > To act on install from lockfile, run before very first `vim.pack.add()`
local fzf_native = vim.pack.get({ 'telescope-fzf-native.nvim' }, { info = false })[1]
if fzf_native then
    local fzf_native_installed = #vim.fn.glob(fzf_native.path .. '/build/libfzf.*', false, true) > 0
    if not fzf_native_installed then
        build_telescope_fzf_native(fzf_native.path)
    end
end

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
vim.keymap.set('n', '<Leader>fgb', wrap_telescope_fn('git_branches'))         -- 'b' -> 'branches'

-- 'c' -> 'code'
vim.keymap.set('n', '<Leader>fcs', wrap_telescope_fn('lsp_document_symbols'))
