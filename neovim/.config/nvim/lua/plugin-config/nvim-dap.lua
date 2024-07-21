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
    vim.keymap.set('n', '<Leader>ds', sidebar(widgets.frames).toggle) -- 's' => 'stack'
    vim.keymap.set('n', '<Leader>dv', sidebar(widgets.scopes).toggle) -- 'v' => 'variables'

    dap.adapters.lldb = {
        name = 'lldb',
        type = 'executable',
        command = '/opt/homebrew/opt/llvm/bin/lldb-dap',
    }

    dap.adapters['lldb-dap'] = dap.adapters.lldb

    -- https://github.com/mfussenegger/nvim-dap/discussions/869#discussioncomment-8121995
    dap.adapters.cppvsdbg = {
        id = 'cppvsdbg',
        type = 'executable',
        command = 'C:\\Users\\egorbychin\\.vscode\\extensions\\ms-vscode.cpptools-1.20.5-win32-x64\\debugAdapters\\vsdbg\\bin\\vsdbg.exe',
        args = { '--interpreter=vscode' },
        reverse_request_handlers = {
            handshake = function(self, request_payload)
                local utils = require('dap.utils')
                local rpc = require('dap.rpc')

                local signer_path = vim.api.nvim_get_runtime_file('data/vsdbg-sign.js', false)[1]
                assert(signer_path, 'Cannot find `vsdbg-sign.js`')
                local signer_cmd = string.format('node %s %s', signer_path, request_payload.arguments.value)
                local sign_result = io.popen(signer_cmd)
                if sign_result == nil then
                    utils.notify('error while signing handshake', vim.log.levels.ERROR)
                    return
                end

                local signature = sign_result:read('*a')
                signature = string.gsub(signature, '\n', '')
                local response = {
                    type = 'response',
                    seq = 0,
                    command = 'handshake',
                    request_seq = request_payload.seq,
                    success = true,
                    body = {
                        signature = signature
                    }
                }

                local msg = rpc.msg_with_content_length(vim.json.encode(response))
                self.client.write(msg)
            end,
        }
    }

    dap.configurations.cpp = {
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
        {
            name = '(vsdbg) Custom path',
            type = 'cppvsdbg',
            request = 'launch',
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = vim.fn.getcwd(),
            clientID = 'vscode',
            clientName = 'Visual Studio Code',
            columnsStartAt1 = true,
            linesStartAt1 = true,
            locale = 'en',
            pathFormat = 'path'
        },
    }
end
