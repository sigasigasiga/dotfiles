local drw_codestyle = {
    -- tab settings (expandtab changes tabs to spaces)
    tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = true,
    -- autoindent settings. cinoptions are fucky, so tldr:
    -- `l1` = don't fuck up curly braces in `case`
    -- `g0` = access modifiers are not indented
    -- `N-s` = namespaces are not indented
    -- `(0,W4` = `void foo(<CR> /* next line is 4 space indented`
    -- `(s,m1` = `void foo(<CR>` will have `)` on beginning of the next line
    -- `j1` = don't fuck up lambda definitions in an argument list
    ai = true, cin = true, cinoptions = 'l1,g0,N-s,(0,W4,(s,m1,j1'
}

local gnu_codestyle = {
    tabstop = 8, shiftwidth = 2, softtabstop = 2, expandtab = false,
    ai = true, cin = true, cinoptions='>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1'
}

local glidewell_codestyle = {
    tabstop = 4, shiftwidth = 4, softtabstop = 4, expandtab = true,
    -- `:0` = place `case`s with the same indent as `switch`
    -- `g0` = access modifiers are not indented
    -- `N-s` = namespaces are not indented
    -- `(0` = table-style argument formatting
    -- `j1` = don't fuck up lambda definitions in an argument list
    ai = true, cin = true, cinoptions = ':0,g0,N-s,(0,j1'
}

local set_codestyle = function(style)
    for k, v in pairs(style) do
        vim.opt[k] = v
    end
end

-- set default codestyle
set_codestyle(drw_codestyle)

-- TODO: reset the codestyle when opening another file after opening a glidewell file (idk how tho)
local id = vim.api.nvim_create_augroup('ProjectSetup', {})
vim.api.nvim_create_autocmd({'BufRead', 'BufEnter'}, {
    pattern = 'C:/projects/glidewell/*',
    group = id,
    callback = function()
        set_codestyle(glidewell_codestyle)
    end
})

-- TODO: FIXME: create functions to easily switch between codestyles
