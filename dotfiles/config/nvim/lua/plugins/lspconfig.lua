return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- this is need to guarantee that neoconf will be called before lspconfig
            { "folke/neoconf.nvim", config = true },
        },
    },
}
