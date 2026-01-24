return {
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    opts = function()
      local dap = require("dap")
      dap.adapters.codelldb = {
        type = "executable",
        command = "codelldb",
      }
      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            local opts = {}
            return coroutine.create(function(coro)
              require("telescope.pickers")
                .new(opts, {
                  prompt_title = "Path to executable",
                  finder = require("telescope.finders").new_oneshot_job({
                    "fd",
                    "--hidden",
                    "--no-ignore",
                    "--type",
                    "x",
                  }, {}),
                  sorter = require("telescope.config").values.generic_sorter(opts),
                  attach_mappings = function(bufnr)
                    require("telescope.actions").select_default:replace(function()
                      require("telescope.actions").close(bufnr)
                      coroutine.resume(coro, require("telescope.actions.state").get_selected_entry()[1])
                    end)
                    return true
                  end,
                })
                :find()
            end)
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp

      -- catppuccin
      local sign = vim.fn.sign_define
      sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })

      -- dap-ui
      local dapui = require("dapui")
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      return {}
    end,
  },
}
