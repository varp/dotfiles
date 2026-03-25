return {
    'zhisme/copy_with_context.nvim',
    config = function()
        require('copy_with_context').setup({
            -- Customize mappings
            mappings = {
                relative = '<leader>ycy',
                absolute = '<leader>ycY',
                remote = '<leader>ycr',
            },
            formats = {
                default = '# {filepath}:{line}', -- Used by relative and absolute mappings
                remote = '# {remote_url}',
            },
            -- whether to trim lines or not
            trim_lines = false,
        })
    end
}
