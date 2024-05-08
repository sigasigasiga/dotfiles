return function()
    local dap = require('dap')
    local widgets = require('dap.ui.widgets')
    local sidebar = widgets.sidebar

    vim.keymap.set('n', '<F5>', dap.continue)
    vim.keymap.set('n', '<F10>', dap.step_over)
    vim.keymap.set('n', '<F11>', dap.step_into)
    vim.keymap.set('n', '<F12>', dap.step_out)

    -- 'd' stands for 'debug'
    vim.keymap.set('n', '<Leader>db', dap.toggle_breakpoint)
    vim.keymap.set('n', '<Leader>dr', dap.repl.open)
    vim.keymap.set({'n', 'v'}, '<Leader>dh', widgets.hover)
    vim.keymap.set('n', '<Leader>df', sidebar(widgets.frames).toggle)
    vim.keymap.set('n', '<Leader>dv', sidebar(widgets.scopes).toggle) -- 'v' => 'variables'

    dap.adapters.lldb = {
        type = 'executable',
        command = '/opt/homebrew/opt/llvm/bin/lldb-dap',
        name = 'lldb',
    }

    dap.configurations.cpp = {
        {
            name = 'Launch',
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
end
