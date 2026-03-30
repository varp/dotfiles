return {
    {
        "mfussenegger/nvim-lint",
        opts = function(_, opts)
            opts.linters_by_ft = opts.linters_by_ft or {}

            -- Проверяем, есть ли уже таблица линтеров для Go
            if type(opts.linters_by_ft["go"]) == "table" then
                -- Фильтруем список, оставляя все, кроме "golangci-lint"
                opts.linters_by_ft["go"] = vim.tbl_filter(function(linter)
                    return linter ~= "golangci-lint"
                end, opts.linters_by_ft["go"])
            end

            -- Делаем то же самое для gomod
            if type(opts.linters_by_ft["gomod"]) == "table" then
                opts.linters_by_ft["gomod"] = vim.tbl_filter(function(linter)
                    return linter ~= "golangci-lint"
                end, opts.linters_by_ft["gomod"])
            end
        end,
    },
}
