local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- Timeout: Nếu bấm Ctrl+A xong ngâm 1 giây không bấm gì tiếp theo, nó tự hủy lệnh.
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 2000 }
-- Dùng PowerShell làm Shell mặc định thay vì CMD rác
config.default_prog = { 'pwsh.exe', '-NoLogo' }
config.scrollback_lines = 2000

-- Giao diện vô cực (Không viền, không thanh tiêu đề)
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.enable_tab_bar = false -- Tắt Tab Bar để tối đa diện tích code
config.integrated_title_button_style = "Windows"
config.integrated_title_button_color = "auto"

-- Tối ưu GPU Render, giảm độ trễ (Input Latency) xuống thấp nhất
config.front_end = "WebGpu"
config.animation_fps = 1
config.max_fps = 144

-- Font chuẩn coding có hỗ trợ Ligatures và Nerd Font
config.font = wezterm.font 'JetBrains Mono' -- Cascadia Code
config.font_size = 13.0

-- DANH SÁCH BÍ THUẬT (Keybinds)
config.keys = {
	-- 🔪 CẮT MÀN HÌNH (SPLIT PANES)
	{
		key = '-',
		mods = 'LEADER',
		action = act.SplitVertical { domain = 'CurrentPaneDomain' },
	},

	-- Bấm Leader, sau đó bấm phím xuyệt (|) hoặc (\\) để cắt dọc (Trái/Phải)
	{
		key = '\\',
		mods = 'LEADER',
		action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
	},

	-- 🏃‍♂️ ĐIỀU HƯỚNG BẰNG NEOVIM STYLE (H J K L)
	-- Bấm Leader + h/j/k/l để nhảy sang các Pane tương ứng
	{ key = 'h', mods = 'ALT', action = act.ActivatePaneDirection('Left') },
    { key = 'j', mods = 'ALT', action = act.ActivatePaneDirection('Down') },
    { key = 'k', mods = 'ALT', action = act.ActivatePaneDirection('Up') },
    { key = 'l', mods = 'ALT', action = act.ActivatePaneDirection('Right') },

	-- 📏 CHỈNH KÍCH THƯỚC PANE (RESIZE)
	-- Bấm Ctrl+A, sau đó bấm phím 'r' để vào Mode.
	{
        key = 'r',
        mods = 'LEADER',
        action = act.ActivateKeyTable {
            name = 'resize_pane',
            one_shot = false, -- False để không bị văng ra sau 1 lần bấm!
            timeout_milliseconds = 2000, -- Ngâm 2s không gõ gì thì tự thoát Mode
        },
    },

	-- Bấm Leader + X để tắt Pane hiện tại (Xác nhận an toàn)
	{
		key = 'x',
		mods = 'LEADER',
		action = act.CloseCurrentPane { confirm = true },
	},

	-- Phóng to 1 Pane ra toàn màn hình (và ngược lại)
	{
	key = 'z',
	mods = 'LEADER',
	action = act.TogglePaneZoomState,
	},
	
	-- Bấm Ctrl+A, sau đó bấm tiếp Ctrl+A để gửi tín hiệu "Về đầu dòng" thẳng vào Shell
	{
        key = 'a',
        mods = 'LEADER|CTRL',
        action = act.SendKey { key = 'a', mods = 'CTRL' },
    },
}

config.key_tables = {
    -- Bảng phím chỉ có tác dụng khi đang ở trong Mode 'resize_pane'
    resize_pane = {
        { key = 'LeftArrow', action = act.AdjustPaneSize { 'Left', 5 } },
        { key = 'h', action = act.AdjustPaneSize { 'Left', 5 } },
        
        { key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 5 } },
        { key = 'l', action = act.AdjustPaneSize { 'Right', 5 } },
        
        { key = 'UpArrow', action = act.AdjustPaneSize { 'Up', 5 } },
        { key = 'k', action = act.AdjustPaneSize { 'Up', 5 } },
        
        { key = 'DownArrow', action = act.AdjustPaneSize { 'Down', 5 } },
        { key = 'j', action = act.AdjustPaneSize { 'Down', 5 } },

        -- Nút thoát hiểm (Cực kỳ quan trọng, để báo cho WezTerm biết đã cấu hình xong)
        { key = 'Escape', action = 'PopKeyTable' },
        { key = 'Enter', action = 'PopKeyTable' },
        
        -- Nếu gõ nhầm phím ctrl+c để ngắt lệnh thì cũng tự thoát mode luôn cho an toàn
        { key = 'c', mods = 'CTRL', action = 'PopKeyTable' },
    },
}

return config
