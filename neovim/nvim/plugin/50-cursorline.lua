local cursorline_group = vim.api.nvim_create_augroup('siga/cursorline', { clear = false })

-- for some stupid reason, `cursorline` is shown on every window, even if it is inactive
-- here we work it around by enabling it only on the active window and disabling it on the inactive ones
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    group = cursorline_group,
    pattern = "*",
    callback = function()
        vim.opt_local.cursorline = true
    end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    group = cursorline_group,
    pattern = "*",
    callback = function()
        vim.opt_local.cursorline = false
    end,
})

