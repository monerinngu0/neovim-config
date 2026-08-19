vim.api.nvim_create_user_command("Temp", function(opts)
    if opts.args == "clear" then
        vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
        vim.api.nvim_win_set_cursor(0, { 1, 0 })
        return
    end

    local ext = vim.fn.expand("%:e")
    if ext == "" then
        return
    end

    local template_name = opts.args == "" and "default" or opts.args

    local local_filename = template_name .. "." .. ext .. ".nvim"
    local builtin_filename = template_name .. "." .. ext

    local local_path = vim.fs.joinpath(
        vim.fn.getcwd(),
        local_filename
    )

    local template_dir = vim.fs.joinpath(
        vim.fn.stdpath("config"),
        "lua",
        "commands",
        "templates"
    )

    local builtin_path = vim.fs.joinpath(
        template_dir,
        builtin_filename
    )

    local path
    if vim.fn.filereadable(local_path) == 1 then
        path = local_path
    elseif vim.fn.filereadable(builtin_path) == 1 then
        path = builtin_path
    else
        vim.notify(
            "テンプレートが存在しません: "
                .. local_filename
                .. " または "
                .. builtin_filename,
            vim.log.levels.WARN
        )
        return
    end

    local lines = vim.fn.readfile(path)

    local author = vim.fn.getenv("USER") or "unknown"
    local created = os.date("%d.%m.%Y %H:%M:%S")
    local filename = vim.fn.expand("%:t")

    for i, line in ipairs(lines) do
        line = line:gsub("%${AUTHOR}", author)
        line = line:gsub("%${CREATED}", created)
        line = line:gsub("%${FILENAME}", filename)