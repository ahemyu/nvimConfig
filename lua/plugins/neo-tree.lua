return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      bind_to_cwd = true,
      follow_current_file = { enabled = true },
    },
  },
  keys = {
    { "<leader>e", "<cmd>Neotree toggle dir=./<cr>", desc = "Explorer (cwd)" },
  },
}
