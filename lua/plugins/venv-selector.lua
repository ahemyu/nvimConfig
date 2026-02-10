return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-telescope/telescope.nvim",
  },
  branch = "regexp",
  opts = {
    settings = {
      options = {
        notify_user_on_venv_activation = true,
      },
      search = {
        uv = {
          command = "fd -t d -a .venv$ $CWD",
        },
      },
    },
  },
  event = "VeryLazy",
  keys = {
    { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
    { "<leader>cc", "<cmd>VenvSelectCached<cr>", desc = "Select Cached VirtualEnv" },
  },
}
