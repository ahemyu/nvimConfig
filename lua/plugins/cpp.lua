local function ensure_items(list, items)
  for _, item in ipairs(items) do
    if not vim.tbl_contains(list, item) then
      table.insert(list, item)
    end
  end
end

return {
  { import = "lazyvim.plugins.extras.lang.clangd" },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      ensure_items(opts.ensure_installed, {
        "clangd",
        "clang-format",
        "codelldb",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      ensure_items(opts.ensure_installed, {
        "c",
        "cpp",
      })
    end,
  },
}
