local wezterm = require('wezterm')
local config = wezterm.config_builder()

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    require('windows').fill_config(config)
end

-- currently it is required to call `common` after the platform-specific configs,
-- because we need to know if `config.launch_menu` is filled or not
require('common').fill_config(config)

return config
