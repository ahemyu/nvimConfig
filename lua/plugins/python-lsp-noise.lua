return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "basic",
              diagnosticSeverityOverrides = {
                reportMissingParameterType = "none",
                reportMissingTypeArgument = "none",
                reportMissingTypeStubs = "none",
                reportUnknownArgumentType = "none",
                reportUnknownLambdaType = "none",
                reportUnknownMemberType = "none",
                reportUnknownParameterType = "none",
                reportUnknownVariableType = "none",
                reportUntypedBaseClass = "none",
                reportUntypedClassDecorator = "none",
                reportUntypedFunctionDecorator = "none",
                reportUntypedNamedTuple = "none",
              },
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
  },
}
