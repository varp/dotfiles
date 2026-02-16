return {
  {
    "leoluz/nvim-dap-go",
    opts = function(_, opts)
      local dap = require("dap")

      -- command to start headless: dlv debug --headless --listen=:38697 --api-version=2 --accept-multiclient < <(echo "some input to pass to process")
      local attachRemoteConfig = {
        type = "go",
        name = "Connect to Headless (Local)",
        mode = "remote",
        request = "attach",
        port = "38697",
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
