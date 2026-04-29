return {
    "stevearc/oil.nvim",

    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },

    lazy = false,

    config = function()
        require("oil").setup({
            default_file_explorer = true,
            view_options = {
                show_hidden = true,
            },
        })

        -- keymap
        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open file tree" })
    end,
}