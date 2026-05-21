require("options")
require("keymaps")

-- lazy.nvim
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")

require("lazy").setup("plugins")

local function load_dir(dir)
  local base = vim.fn.stdpath("config") .. "/lua/" .. dir
  local handle = vim.loop.fs_scandir(base)

  while handle do
    local name, type = vim.loop.fs_scandir_next(handle)
    if not name then break end

    if type == "file" and name:sub(-4) == ".lua" then
      local module = dir .. "." .. name:gsub("%.lua$", "")
      require(module)
    elseif type == "directory" then
      load_dir(dir .. "." .. name)
    end
  end
end

load_dir("config")
load_dir("commands")