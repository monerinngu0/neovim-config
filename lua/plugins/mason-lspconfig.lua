return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "williamboman/mason.nvim",
    },
    config = function()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "clangd",
                "pyright",
                "lua_ls",
                "rust_analyzer",
            },
            automatic_installation = true,
        })
    end,
}