return {
    "nvim-neotest/neotest",
    opts = function(_, opts)
        opts.adapters = {
            ["neotest-golang"] = {
                testify_enabled = true,
            },
        }
    end,
}
