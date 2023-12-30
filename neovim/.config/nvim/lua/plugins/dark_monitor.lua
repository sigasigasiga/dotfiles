local dark_monitor_exe = vim.api.nvim_get_runtime_file('rplugin/neovim-dark-monitor.exe', false)
if next(dark_monitor_exe) == nil then
    return
end

local current_os = vim.loop.os_uname().sysname
if os.getenv('XDG_SESSION_TYPE') == 'tty' then
    return
end

-- Currently Neovim on Windows spawns a named pipe instead of a regular socket on startup,
-- but `neovim-dark-monitor` doesn't support them.
--
-- This is a subject to change on the Neovim side, because Windows has added a support
-- for `AF_UNIX` sockets since 2018 (more info: https://github.com/neovim/neovim/issues/11363 ),
-- but currently we have to work this around by spawning an IP socket manually.
if current_os:find('Windows') and vim.v.servername:find('\\\\.\\pipe') == 1 then
    local server = '127.0.0.1:18623' -- the port was chosen arbitrarily

    -- When we call `serverstart`, the new server socket is added to the end of
    -- the `serverlist()` and there's no way to do that the other way.
    --
    -- At the same time, `v:servername` is always equal to the first element in
    -- the list, so unfortunately we have to stop the old server and spawn
    -- a new one just because we need it to come first in the list.
    assert(#vim.fn.serverlist() == 1, 'More than one RPC server has been started')
    vim.fn.serverstop(vim.v.servername)
    vim.fn.serverstart(server)
end

assert(#dark_monitor_exe == 1)
-- It is better to use `vim.system` on neovim version 0.10+
local job_id = vim.fn.jobstart(dark_monitor_exe, {
    detach = true,
    stdin = nil
})
assert(job_id > 0, 'Unable to start the `neovim-dark-monitor` job')

local set_theme = function(theme)
    if theme == 'dark' then
        vim.o.background = 'dark'
        vim.cmd('colorscheme gruvbox')
    elseif theme == 'light' then
        vim.o.background = 'light'
        vim.cmd('colorscheme dawnfox')
    else
        vim.print(string.format('neovim-dark-monitor: Theme is unknown (%s)', tostring(theme)))
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
