local function toggle_telescope(harpoon_files)
	local conf = require("telescope.config").values
	local themes = require("telescope.themes")

	local file_paths = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end

	local opts = themes.get_ivy({
		prompt_title = " 󰛔 Harpoon Working List ", -- Thêm icon cho chanh sả
	})

	require("telescope.pickers")
		.new(opts, {
			prompt_title = opts.prompt_title,
			finder = require("telescope.finders").new_table({
				results = file_paths,
			}),
			previewer = conf.file_previewer(opts),
			sorter = conf.generic_sorter(opts),
		})
		:find()
end

return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},

	-- 🚀 Raizo's Pro Tip: Dùng bảng `keys` để Which-Key tự động nhận diện desc
	-- Đồng thời Lazy.nvim sẽ CHỈ load Harpoon khi bro bấm 1 trong các phím này!
	keys = {
		{
			"<leader>a",
			function()
				require("harpoon"):list():add()
			end,
			desc = "Harpoon: Add File",
		},
		{
			"<C-e>",
			function()
				local h = require("harpoon")
				h.ui:toggle_quick_menu(h:list())
			end,
			desc = "Harpoon: Quick Menu",
		},
		{
			"<leader>fl",
			function()
				toggle_telescope(require("harpoon"):list())
			end,
			desc = "Harpoon: Telescope Picker",
		},
		{
			"<C-p>",
			function()
				require("harpoon"):list():prev()
			end,
			desc = "Harpoon: Previous File",
		},
		{
			"<C-n>",
			function()
				require("harpoon"):list():next()
			end,
			desc = "Harpoon: Next File",
		},
	},

	config = function()
		require("harpoon"):setup({
			settings = {
				save_on_toggle = true, -- Tự động lưu trạng thái khi đóng/mở menu
				sync_on_ui_close = true,
			},
		})
	end,
}
