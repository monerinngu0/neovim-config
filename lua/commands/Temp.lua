vim.api.nvim_create_user_command("Temp", function(opts)
  if opts.args == "clear" then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
    vim.api.nvim_win_set_cursor(0, {1, 0})
    return
  end

  local ext = vim.fn.expand("%:e")
  if ext == "" then return end

  local template_dir = vim.fn.stdpath("config") .. "/lua/commands/templates"

  local filename = (opts.args == "" and "default" or opts.args) .. "." .. ext
  local path = template_dir .. "/" .. filename

  if vim.fn.filereadable(path) == 0 then
    print("テンプレが存在しません: " .. filename)
    return
  end

  local lines = vim.fn.readfile(path)

  local author = vim.fn.getenv("USER") or "unknown"
  local created = os.date("%d.%m.%Y %H:%M:%S")
  local filename_only = vim.fn.expand("%:t")

  for i, line in ipairs(lines) do
    line = line:gsub("%${AUTHOR}", author)
    line = line:gsub("%${CREATED}", created)
    line = line:gsub("%${FILENAME}", filename_only)
    lines[i] = line
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

  local function find_func(name)
    for i, line in ipairs(lines) do
      if line:match("^%s*[%w_:<>~*&]+%s+" .. name .. "%s*%(") then
        local col = line:find("{")
        if col then return { i, col - 1 } end
        for j = i + 1, #lines do
          local col2 = lines[j]:find("{")
          if col2 then return { j, col2 - 1 } end
        end
      end
    end
    return nil
  end

  local func_pos = find_func("solve") or find_func("main")

  if func_pos then
    vim.api.nvim_win_set_cursor(0, func_pos)
  end

end, {
  nargs = "?",
  complete = function(arg_lead)
    local ext = vim.fn.expand("%:e")
    if ext == "" then return {} end

    local template_dir = vim.fn.stdpath("config") .. "/lua/commands/templates"
    local files = vim.fn.readdir(template_dir)

    local result = {}
    for _, file in ipairs(files) do
      if file:sub(-( #ext + 1 )) == "." .. ext then
        local name = file:gsub("%." .. ext .. "$", "")
        if name:match("^" .. arg_lead) then
          table.insert(result, name)
        end
      end
    end

    return result
  end,
})