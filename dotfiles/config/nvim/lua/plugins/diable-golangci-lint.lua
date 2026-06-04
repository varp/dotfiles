return {
    {
        "mason-org/mason.nvim",
        opts = function(_, opts)
            opts.ensure_installed = vim.tbl_filter(function(name)
                -- very cpu and memory intensive
                return name ~= "golangci-lint" or name ~= "golangci-lint-langserver"
            end, opts.ensure_installed or {})
        end,
    },
    {
        "mfussenegger/nvim-lint",
        opts = function(_, opts)
            if opts.linters_by_ft and opts.linters_by_ft.go then
                opts.linters_by_ft.go = vim.tbl_filter(function(l)
                    return l ~= "golangcilint"
                end, opts.linters_by_ft.go)
            end
        end,
    },
}
