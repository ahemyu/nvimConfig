return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "off",
            },
          },
        },
      },
      ruff = {
        init_options = {
          settings = {
            logLevel = "error",
            configuration = {
              lint = {
                ignore = { "ANN" },
              },
            },
          },
        },
      },
    },
    setup = {
      basedpyright = function(_, server_opts)
        server_opts.handlers = server_opts.handlers or {}
        server_opts.handlers["textDocument/publishDiagnostics"] = function() end
      end,
    },
  },
}
