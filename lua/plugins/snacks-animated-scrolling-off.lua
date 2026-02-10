return {
	"folke/snacks.nvim",
	opts = {
		scroll = {
			enabled = false, -- Disable scrolling animations
		},
		terminal = {
			win = {
				cwd = vim.uv.cwd(), -- Always use the directory where nvim was started
			},
		},
	},
}
