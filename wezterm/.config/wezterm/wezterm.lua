local wezterm = require('wezterm')

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
function get_appearance()
    if wezterm.gui then
        return wezterm.gui.get_appearance()
    end
    return 'Dark'
end

function scheme_for_appearance(appearance)
    if appearance:find('Dark') then
        return 'GruvboxDark'
    else
        return 'dawnfox'
    end
end

return {
    color_scheme = scheme_for_appearance(get_appearance()),
    font = wezterm.font('Source Code Pro'),
    hide_tab_bar_if_only_one_tab = true,
}
