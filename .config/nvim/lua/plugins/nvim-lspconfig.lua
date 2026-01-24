return {
  "neovim/nvim-lspconfig",
  config = function()
    local builtin = require("telescope.builtin")

    -- Integration with nvim-cmp
    vim.lsp.config("*", {
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
    })

    -- LSP keymaps
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function()
        vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = true })
        vim.keymap.set("n", "<M-k>", vim.lsp.buf.signature_help, { buffer = true })
        vim.keymap.set("n", "<M-r>", builtin.lsp_references, { buffer = true })
      end,
    })

    -- Diagnostics
    vim.diagnostic.config({ virtual_text = true })
    vim.keymap.set("n", "<M-d>", vim.diagnostic.open_float)
    vim.keymap.set("n", "<M-q>", vim.diagnostic.setqflist)

    vim.lsp.enable({
      "bashls",
      "clangd",
      "emmet_language_server",
      "gdscript",
      "hls",
      "lua_ls",
      "pyright",
      "ruff",
      "rust_analyzer",
    })

    vim.lsp.config.clangd = {
      cmd = { "clangd", "--header-insertion=never" },
    }

    vim.lsp.config.lua_ls = {
      on_init = function(client)
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if
            path ~= vim.fn.stdpath("config")
            and (vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc"))
          then
            return
          end
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
          runtime = {
            version = "LuaJIT",
            -- Tell the language server how to find Lua modules same way as Neovim
            -- (see `:h lua-module-load`)
            path = {
              "lua/?.lua",
              "lua/?/init.lua",
            },
          },

          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
            },
          },
        })
      end,
      settings = {
        Lua = {},
      },
    }
  end,
}
