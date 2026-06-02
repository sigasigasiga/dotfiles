-- warn when running inside another neovim's terminal emulator.
if vim.env.NVIM then
    vim.notify('You are in a nested neovim instance', vim.log.levels.WARN)
end
