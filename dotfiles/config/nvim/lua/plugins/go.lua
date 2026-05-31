return {
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
    },
    opts = function(_, opts)
      require("go").setup(opts)
      -- return {
      --   -- lsp_keymaps = false,
      --   -- other options
      -- }
    end,
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },
}
