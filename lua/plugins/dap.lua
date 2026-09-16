-- Debugging for .NET via nvim-dap + netcoredbg (installed by mason-tool-installer
-- in lsp.lua). nvim-dap-ui gives a variables/scopes/watches panel.
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
      {
        "<leader>dB",
        function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
        desc = "Debug: Conditional Breakpoint",
      },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Debug: Toggle REPL" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Debug: Terminate" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()

      -- Open/close the UI automatically around a session
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

      -- Gutter signs
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticWarn", linehl = "Visual" })

      -- Resolve the mason-installed netcoredbg.exe directly (avoids the .cmd shim)
      local function netcoredbg_cmd()
        local mason = vim.fn.stdpath("data") .. "/mason"
        local iswin = vim.uv.os_uname().sysname:lower():find("windows") ~= nil
        local exe = mason .. "/packages/netcoredbg/netcoredbg/netcoredbg" .. (iswin and ".exe" or "")
        if vim.fn.filereadable(exe) == 1 then
          return exe
        end
        return "netcoredbg" -- fallback: rely on PATH
      end

      dap.adapters.coreclr = {
        type = "executable",
        command = netcoredbg_cmd(),
        args = { "--interpreter=vscode" },
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
            -- Point at your built DLL (run `dotnet build` first)
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
          end,
        },
        {
          -- For a process already started with `dotnet run` (e.g. GSCLite's web app,
          -- or something started outside nvim-dap entirely). Filtered to "GSCLite" by
          -- default since that's the apphost name this repo's web app runs as; widen
          -- or drop the filter to attach to something else.
          type = "coreclr",
          name = "attach - netcoredbg",
          request = "attach",
          processId = function() return require("dap.utils").pick_process({ filter = "GSCLite" }) end,
        },
      }
    end,
  },
}
