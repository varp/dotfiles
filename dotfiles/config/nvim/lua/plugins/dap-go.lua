return {
  {
    "leoluz/nvim-dap-go",
    opts = function(_, opts)
      local dap = require("dap")
      -- dap.setup(opts)

      local attachRemoteConfig = {
        type = "go",
        name = "Attach remote",
        mode = "remote",
        request = "attach",
      }

      if dap.configurations.go then
        table.insert(dap.configurations.go, attachRemoteConfig)
        for _, cfg in ipairs(dap.configurations.go) do
          cfg.outputMode = "remote"
        end
      end
    end,
  },
}
