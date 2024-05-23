local wezterm = require('wezterm')

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
local get_appearance = function()
    if wezterm.gui then
        return wezterm.gui.get_appearance()
    end
    return 'Dark'
end

local scheme_for_appearance = function(appearance)
    if appearance:find('Dark') then
        return 'GruvboxDark'
    else
        return 'dawnfox'
    end
end

local launch_menu = {}
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    launch_menu = {
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

return {
    color_scheme = scheme_for_appearance(get_appearance()),
    font = wezterm.font('Source Code Pro'),
    launch_menu = launch_menu,
    hide_tab_bar_if_only_one_tab = next(launch_menu) == nil
}
