local M = {}

local wezterm = require('wezterm')

M.fill_config = function(config)
    config.launch_menu = {
        {
            label = 'PowerShell 7',
            args = { 'C:/Program Files/PowerShell/7/pwsh.exe', '-noe' }
        },
        {
            label = 'bash dev',
            args = { 'C:/Program Files/Git/bin/bash.exe' },
            cwd = 'C:/dev/'
        },
        {
            label = 'PowerShell 7 for VS 2022',
            args = {
                'C:/Program Files/PowerShell/7/pwsh.exe',
                '-noe',
                '-c',
                '&{Import-Module "C:/Program Files/Microsoft Visual Studio/2022/Community/Common7/Tools/Microsoft.VisualStudio.DevShell.dll"; Enter-VsDevShell a2247972}'
            }
        },
        {
            label = 'PowerShell 7 for VS 2019',
            args = {
                'C:/Program Files/PowerShell/7/pwsh.exe',
                '-noe',
                '-c',
                '&{Import-Module "C:/Program Files (x86)/Microsoft Visual Studio/2019/Professional/Common7/Tools/Microsoft.VisualStudio.DevShell.dll"; Enter-VsDevShell bb73eaa2}'
            }
        },
        {
            label = 'Legacy PowerShell',
            args = { 'powershell.exe', '-NoLogo' },
        }
    }
end

return M
