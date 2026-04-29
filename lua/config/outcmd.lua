vim.api.nvim_create_autocmd("BufNewFile", {
  callback = function()
    local ext = vim.fn.expand("%:e")
    if ext == "" then
      return
    end

    local template_dir = vim.fn.stdpath("config") .. "/lua/commands/templates"
    local path = template_dir .. "/default." .. ext

    if vim.fn.filereadable(path) == 1 then
      vim.cmd("Temp")
    end
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)

        if mark[1] > 0 and mark[1] <= lcount then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})