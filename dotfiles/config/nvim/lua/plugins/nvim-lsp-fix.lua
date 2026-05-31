return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            setup = {
                gopls = function() end, -- nvim 0.12+ do the job out of the box
            },
        },
    },
}
