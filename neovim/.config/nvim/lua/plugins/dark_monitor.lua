local dark_monitor_exe = vim.api.nvim_get_runtime_file('rplugin/neovim-dark-monitor.exe', false)
if next(dark_monitor_exe) == nil then
    return
end

local current_os = vim.loop.os_uname()
if os.getenv('XDG_SESSION_TYPE') == 'tty' then
    return
end

local rpc_socket = vim.v.servername

-- Currently Neovim on Windows spawns a named pipe instead of a regular socket on startup,
-- but `neovim-dark-monitor` doesn't support them.
--
-- This is a subject to change on the Neovim side, because Windows has added a support
-- for `AF_UNIX` sockets since 2018 (more info: https://github.com/neovim/neovim/issues/11363 ),
-- but currently we have to work this around by spawning an IP socket manually.
--
-- Under WSL we need to run the Win32 executable to make it actually work, but Win32 applications
-- cannot connect to the UNIX sockets that are spawned in the VM, so we also have to spawn an IP socket
local is_windows_pipes = current_os.sysname:find('Windows') and rpc_socket:find('\\\\.\\pipe') == 1
local is_wsl = current_os.release:find('WSL')
if is_windows_pipes or is_wsl then
    -- start listening on all IP addresses on an arbitrary port
    rpc_socket = vim.fn.serverstart('0.0.0.0:0')
end

assert(#dark_monitor_exe == 1)
assert(type(rpc_socket) == 'string')
-- It is better to use `vim.system` on neovim version 0.10+
local job_id = vim.fn.jobstart({dark_monitor_exe[1], '--nvim-sock', rpc_socket}, {
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
