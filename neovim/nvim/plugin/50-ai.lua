-- the  command ----------------------------------------------------------------
vim.api.nvim_create_user_command(
    'Ai',
    function(opts)
        local cli_cmd = 'claude'

        if vim.fn.executable(cli_cmd) == 0 then
            vim.notify('`claude` is not executable', vim.log.levels.ERROR)
            return
        end

        -- `:terminal` honors modifiers itself (`:tab Ai`, `:vert Ai`, `:botright Ai`, ...).
        -- Without one it reuses the current window, like plain `:terminal`.
        vim.cmd.terminal { args = vim.list_extend({ cli_cmd }, opts.fargs), mods = opts.smods }
        vim.keymap.set('t', '<Esc>', vim.cmd.stopinsert, { buffer = true })

        -- Claude Code draws on the alternate screen, so the buffer has no scrollback
        -- Let terminal mode forward the wheel to Claude Code
        for _, key in ipairs { '<ScrollWheelUp>', '<ScrollWheelDown>' } do
            vim.keymap.set('n', key, 'i' .. key, { buffer = true })
        end

        vim.cmd.startinsert()
    end,
    { nargs = '*', desc = 'Run Claude Code in a terminal window' }
)
