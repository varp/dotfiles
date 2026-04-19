return {
    "linrongbin16/gitlinker.nvim",
    cmd = "GitLink",
    config = function(_, opts) -- do by config to get all opts passed from .lazy.lua in a project dir
        local gitlab_domain = opts.custom_gitlab_domain or nil
        -- delete custom key after use
        opts.custom_gitlab_domain = nil

        --
        if not gitlab_domain then
            return
        end

        local key = "^" .. gitlab_domain
        local base_url = "https://" .. gitlab_domain .. "/"
        opts.router = opts.router or {}

        opts.router.browse = opts.router.browse or {}
        opts.router.browse[key] = base_url
            .. "{_A.ORG}/"
            .. "{_A.REPO}/blob/"
            .. "{_A.REV}/"
            .. "{_A.FILE}"
            .. "#L{_A.LSTART}"
            .. "{(_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or '')}"

        opts.router.blame = opts.router.blame or {}
        opts.router.blame[key] = base_url
            .. "{_A.ORG}/"
            .. "{_A.REPO}/blame/"
            .. "{_A.REV}/"
            .. "{_A.FILE}"
            .. "#L{_A.LSTART}"
            .. "{(_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or '')}"

        opts.router.default_branch = opts.router.default_branch or {}
        opts.router.default_branch[key] = base_url
            .. "{_A.ORG}/"
            .. "{_A.REPO}/blob/"
            .. "{_A.DEFAULT_BRANCH}/"
            .. "{_A.FILE}"
            .. "#L{_A.LSTART}"
            .. "{(_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or '')}"

        opts.router.current_branch = opts.router.current_branch or {}
        opts.router.current_branch[key] = base_url
            .. "{_A.ORG}/"
            .. "{_A.REPO}/blob/"
            .. "{_A.CURRENT_BRANCH}/"
            .. "{_A.FILE}"
            .. "#L{_A.LSTART}"
            .. "{(_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or '')}"
        ---

        -- setup the plugin
        require("gitlinker").setup(opts)
    end,
    keys = {
        { "<leader>gy", "<cmd>GitLink<cr>",  mode = { "n", "v" }, desc = "Yank git link" },
        { "<leader>gY", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git link" },
    },
}
