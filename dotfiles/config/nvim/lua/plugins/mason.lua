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
}
