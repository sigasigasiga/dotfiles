vim.pack.add {
    'https://github.com/sigasigasiga/nvim-switch',
}

local switch = require 'switch'

vim.api.nvim_create_user_command(
    'Switch',
    function(args) switch.pick(args.bang) end,
    { bang = true, desc = 'Switch UI to another Nvim server (! stops current server if unused)' }
)

vim.api.nvim_create_user_command(
    'SetInstanceName',
    function(args) switch.instance_name = args.args end,
    { nargs = 1, desc = 'Set the current Nvim server instance name' }
)
