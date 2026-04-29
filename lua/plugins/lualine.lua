return {
    "nvim-lualine/lualine.nvim",

    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },

    lazy = false,

    config = function()
        require("lualine").setup({
            options = {
                theme = "auto",
                globalstatus = true,
                section_separators = "",
                component_separators = "",
            },

            sections = {
                lualine_a = {"mode"},
                lualine_b = {"branch"},
                lualine_c = {"filename"},
                lualine_x = {"encoding", "filetype"},
                lualine_y = {"progress"},
                lualine_z = {"location"},
            },
        })
    end,
}