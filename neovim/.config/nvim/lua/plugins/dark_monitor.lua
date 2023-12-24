if os.getenv('XDG_SESSION_TYPE') == 'tty' then
    return
end

local dark_monitor_exe = vim.api.nvim_get_runtime_file('rplugin/neovim-dark-monitor', false)[1]
if type(dark_monitor_exe) == 'string' then
    local run_cmd = string.format('call jobstart("%s", {"detach": v:true})', dark_monitor_exe)
    vim.cmd(run_cmd)
end

local set_theme = function(theme)
    if theme == 'dark' then
        vim.o.background = 'dark'
        vim.cmd('colorscheme gruvbox')
    elseif theme == 'light' then
        vim.o.background = 'light'
        vim.cmd('colorscheme dawnfox')
    else
        vim.print(table.concat{'neovim-dark-monitor: Theme is unknown (', tostring(theme), ')'})
    end
end

local dark_monitor_group = vim.api.nvim_create_augroup('DarkMonitorConfig', { clear = true })
vim.api.nvim_create_autocmd('User', {
    group = dark_monitor_group,
    pattern = 'OnDarkMonitorConnected',
    callback = function(ev)
        set_theme(DarkMonitorQuery())
    end
})
vim.api.nvim_create_autocmd('User', {
    group = dark_monitor_group,
    pattern = 'OnDarkMonitorThemeChange',
    callback = function(ev)
        local theme = ev.data
        set_theme(theme)
    end
})
