local wezterm = require('wezterm')
local config = wezterm.config_builder()

require('common').fill_config(config)

return config
