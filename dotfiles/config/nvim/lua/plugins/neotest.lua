return {
    "nvim-neotest/neotest",
    dependencies = {
        'folke/neoconf.nvim'
    },
    opts = function(_, opts)
        local neoconf = require("neoconf")

        local go_test_args = neoconf.get("neotest.adapters.neotest-golang.go_test_args") or nil
        local go_list_args = neoconf.get("neotest.adapters.neotest-golang.go_list_args") or nil
        local dap_go_opts = neoconf.get("neotest.adapters.neotest-golang.dap_go_opts") or nil
        local testify_enabled = neoconf.get("neotest.adapters.neotest-golang.testify_enabled") or nil
        local env = neoconf.get("neotest.adapters.neotest-golang.env") or nil

        opts.adapters = opts.adapters or {}
        if go_test_args then
            opts.adapters["neotest-golang"].go_test_args = go_test_args
        end
        if go_list_args then
            opts.adapters["neotest-golang"].go_list_args = go_list_args
        end
        if dap_go_opts then
            opts.adapters["neotest-golang"].dap_go_opts = dap_go_opts
        end
        if testify_enabled then
            opts.adapters["neotest-golang"].testify_enabled = testify_enabled
        end
        if env then
            opts.adapters["neotest-golang"].env = env
        end

        -- vim.print("neotest.opts after", opts)
    end,
}
