local M = {}

local wezterm = require('wezterm')

local get_appearance = function()
    -- wezterm.gui is not available to the mux server, so take care to
    -- do something reasonable when this config is evaluated by the mux
    if wezterm.gui then
        return wezterm.gui.get_appearance()
    end
    return 'Dark'
end

local scheme_for_appearance = function(appearance)
    if appearance:find('Dark') then
        return 'GruvboxDark'
    else
        return 'Catppuccin Latte'
    end
end

M.fill_config = function(config)
    local hide_tab_bar = type(config.launch_menu) == 'table' and next(config.launch_menu) == nil

    config.color_scheme = scheme_for_appearance(get_appearance())
    config.use_fancy_tab_bar = false
    config.font = wezterm.font('JetBrains Mono NL')
    config.hide_tab_bar_if_only_one_tab = hide_tab_bar
end

return M
