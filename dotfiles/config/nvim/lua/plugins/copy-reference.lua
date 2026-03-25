return {
    "cajames/copy-reference.nvim",
    opts = {}, -- optional configuration
    keys = {
        { "<leader>yrf", "<cmd>CopyReference file<cr>", mode = { "n", "v" }, desc = "Copy file path" },
        { "<leader>yl",  "<cmd>CopyReference line<cr>", mode = { "n", "v" }, desc = "Copy file:line reference" },
    },
}
