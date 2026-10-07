return {
    'zhisme/copy_with_context.nvim',
    lazy = false,
    opts = {
        mappings = {
            relative = '<leader>ycy',
            absolute = '<leader>ycY',
            remote = '<leader>ycr',
        },
        formats = {
            default = '# {filepath}:{line}',
            remote = '# {remote_url}',
        },
        trim_lines = false,
    },
    keys = {
        {
            '<leader>ycy',
            function() require('copy_with_context.main').copy_with_context('relative') end,
            mode = 'n',
            desc = 'Copy with context (relative)',
        },
        {
            '<leader>ycy',
            ':<C-U>lua require("copy_with_context.main").copy_with_context("relative", true)<CR>',
            mode = 'x',
            desc = 'Copy with context (relative)',
        },
        {
            '<leader>ycY',
            function() require('copy_with_context.main').copy_with_context('absolute') end,
            mode = 'n',
            desc = 'Copy with context (absolute)',
        },
        {
            '<leader>ycY',
            ':<C-U>lua require("copy_with_context.main").copy_with_context("absolute", true)<CR>',
            mode = 'x',
            desc = 'Copy with context (absolute)',
        },
        {
            '<leader>ycr',
            function() require('copy_with_context.main').copy_with_context('remote') end,
            mode = 'n',
            desc = 'Copy with context (remote)',
        },
        {
            '<leader>ycr',
            ':<C-U>lua require("copy_with_context.main").copy_with_context("remote", true)<CR>',
            mode = 'x',
            desc = 'Copy with context (remote)',
        },
    },
}
