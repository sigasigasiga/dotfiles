local setup_adapters = function()
    local dap = require 'dap'

    dap.adapters['lldb'] = {
        name = 'lldb',
        type = 'executable',
        command = vim.fn.exepath('lldb-dap'),
    }

    dap.adapters['python'] = {
        name = 'debugpy',
        type = 'executable',
        command = vim.fn.exepath('python3'),
        args = { '-m', 'debugpy.adapter' },
    }

    dap.adapters['lldb-dap'] = dap.adapters['lldb']

    local lldb_cfg = {
        {
            name = '(lldb) Custom path',
            type = 'lldb',
            request = 'launch',
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = {},
            runInTerminal = true
        },
    }

    dap.configurations.cpp = lldb_cfg
    dap.configurations.c = lldb_cfg
    dap.configurations.rust = lldb_cfg

    dap.configurations.python = {
        {
            type = 'python',
            request = 'launch',
            name = 'Launch file',
            program = '${file}',
            pythonPath = vim.fn.exepath('python3')
        }
    }
end

local dap_sidebar_toggle = function(name)
    local widgets = require 'dap.ui.widgets'
    widgets.sidebar(widgets[name]).toggle()
end

return {
    'mfussenegger/nvim-dap',
    config = setup_adapters,
    cmd = 'DapContinue',
    keys = {
        { '<F5>', function() require'dap'.continue() end },
        { '<F10>', function() require'dap'.step_over() end },
        { '<F11>', function() require'dap'.step_into() end },
        { '<F12>', function() require'dap'.step_out() end },

        -- 'd' -> 'debug'
        { '<Leader>db', function() require'dap'.toggle_breakpoint() end },

        { '<Leader>dh', function() require'dap.ui.widgets'.hover() end, mode = { 'n', 'v' } },
        { '<Leader>ds', function() dap_sidebar_toggle('frames') end }, -- 's' -> 'stack'
        { '<Leader>dv', function() dap_sidebar_toggle('scopes') end }, -- 'v' -> 'variables'

    },
    dependencies = {
        {
            'stevearc/overseer.nvim',
            opts = {},
        },
    },
}
