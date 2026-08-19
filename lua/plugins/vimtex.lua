return {
    "lervag/vimtex",
    lazy = false,
    init = function()
        vim.g.vimtex_view_method = "general"

        vim.g.vimtex_view_general_viewer =
            "/mnt/c/Users/i2611433/AppData/Local/SumatraPDF/SumatraPDF.exe"

        vim.g.vimtex_view_general_options =
            "-reuse-instance -forward-search @tex @line @pdf"

        vim.g.vimtex_compiler_method = "latexmk"

        vim.g.vimtex_compiler_latexmk = {
            continuous = 1,
            options = {
                "-pdf",
                "-interaction=nonstopmode",
                "-synctex=1",
            },
        }
    end,
}