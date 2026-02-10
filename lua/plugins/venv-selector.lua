return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-telescope/telescope.nvim",
  },
  branch = "regexp",
  ft = "python",
  opts = {
    options = {
      notify_user_on_venv_activation = true,
    },
    search = {
      uv = {
        command = "$FD '/\\.venv/bin/python$' $CWD --full-path --color never -HI -a -L",
      },
    },
  },
  keys = {
    { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
    { "<leader>cc", "<cmd>VenvSelectCached<cr>", desc = "Select Cached VirtualEnv" },
  },
}
