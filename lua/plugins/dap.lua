-- Generic nvim-dap host (dapui, signs, keymaps) for any language that plugs into it.
--
-- .NET/C# debugging is NOT configured here — easy-dotnet.nvim (dotnet.lua) owns it
-- entirely. Its `debugger.auto_register_dap` (on by default) injects a working
-- "easy-dotnet" entry into `dap.configurations.cs` itself, backed by its own
-- RPC build server, which launches the app and a version-matched netcoredbg
-- server-side and hands nvim-dap a TCP port to connect to — no local process
-- spawn/attach from Neovim's side at all.
--
-- A hand-rolled `dap.adapters.coreclr` + launch/attach configs used to live here,
-- pointed at the mason-installed netcoredbg. Removed: that netcoredbg build
-- (3.1.3-1062) doesn't speak net10.0's debug protocol (launch failed at
-- `configurationDone` every time), and separately, attach-to-an-already-running
-- process hits a Jamf-enforced macOS kernel restriction on task_for_pid on this
-- machine (confirmed via EXC_GUARD kills, even for Apple's own signed lldb).
-- easy-dotnet's socket-based approach sidesteps both problems, so there's
-- nothing coreclr-specific left to configure — this file is adapter-agnostic.
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
    end,
  },
}
