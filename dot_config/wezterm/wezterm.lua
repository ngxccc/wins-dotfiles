local wezterm = require 'wezterm'
local config = wezterm.config_builder()

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

return config