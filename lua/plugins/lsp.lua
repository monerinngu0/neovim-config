return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- 共通on_attach（キーマップ）
      local on_attach = function(_, bufnr)
        local opts = { buffer = bufnr }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      end

      -- C++
      vim.lsp.config("clangd", {
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--header-insertion=never",
          "--pch-storage=memory",
          "--function-arg-placeholders=false",
        },
      })

      -- Python
      vim.lsp.config("pyright", {
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = { "pyright-langserver", "--stdio" },
      })

      --[[
      -- Lua
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })]]--

      -- Rust
      vim.lsp.config("rust_analyzer", {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
            },
            checkOnSave = true,
          },
        },
      })

      -- JavaScript / TypeScript
      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = { "typescript-language-server", "--stdio" },

        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
        },

        root_markers = {
          "package.json",
          "tsconfig.json",
          ".git",
        },
      })

      -- LaTeX
      vim.lsp.config("texlab", {
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = { "texlab" },
      })

      -- 有効化
      vim.lsp.enable("clangd")
      vim.lsp.enable("pyright")
      vim.lsp.enable("ts_ls")
      --vim.lsp.enable("lua_ls")
      vim.lsp.enable("rust_analyzer")
      vim.lsp.enable("texlab")
    end,
  },
}