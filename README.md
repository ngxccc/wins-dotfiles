# 🔥 wins-dotfiles: The Ultimate Windows Developer Setup

Chào mừng đến với hệ sinh thái **wins-dotfiles**! Trú ẩn trong repo này là toàn bộ *bí thuật* để biến một con máy tính Windows trắng tinh thành một trạm không gian coding xịn xò chỉ bằng một cú click. 🚀

Thay vì lãng phí hàng giờ đồng hồ để tải file `.exe`, click "Next" nhàm chán và cấu hình từng biến môi trường, hệ thống này tự động hóa 99% quá trình setup.

---

## First Principles & Kiến trúc Under-the-hood

Hệ thống Windows vốn nổi tiếng với sự phân mảnh và "đóng". Tuy nhiên, nếu chúng ta áp dụng **First Principles** từ triết lý Unix vào Windows, ta có thể quản lý nó một cách deterministic (tất định) như Linux. 

**Cơ chế hoạt động cốt lõi:**
1. **Quản lý Dependency khép kín (Dual Package Managers):**
   - Không còn tải `.exe` rác. Mọi thứ được định nghĩa bằng file JSON (`choco-apps.json`, `scoop.json`).
   - **Chocolatey:** Chạy ở tầng System (Admin level) để thao túng các phần mềm nhúng sâu vào OS (Docker, PostgreSQL, Git).
   - **Scoop:** Chạy ở tầng User level, lưu trữ app dưới dạng Portable (`~/scoop/apps`), không chọc ngoáy Registry, giúp môi trường Dev độc lập và clean.
2. **Infrastructure as Code (IaC) qua PowerShell:** File `setup.ps1` đóng vai trò là nhạc trưởng. Nó bootstrap mọi thứ từ con số 0, thiết lập các *Symbolic Links* (Symlinks) để liên kết Dotfiles với cấu hình hệ thống, và tiêm các biến môi trường trực tiếp vào Registry.
3. **Quản lý State với Chezmoi:** Đồng bộ hóa hai chiều (Two-way sync) giữa local filesystem và Git repository, tự động hóa bằng script `dot-sync` ẩn danh qua cơ chế Git Proxy.

---

## Deploy thực chiến & Cấu hình Production

Setup lý thuyết thì hay đấy, nhưng lúc deploy thì phải nhanh gọn lẹ. Dưới đây là hướng dẫn lắp ráp vũ khí và các tính năng ăn tiền nhất của bộ config này.

### 🚀 1. Khởi động lò rèn (Installation)

Chỉ cần mở **PowerShell dưới quyền Administrator** và chạy:

```powershell
# Chạy file setup tự động nạp vũ khí
.\dot_config\powershell\setup.ps1
```

*Script này sẽ làm gì?*
- Khởi tạo lõi Chocolatey & Scoop.
- Auto-install hàng loạt tool như Neovim, WezTerm, Yazi, Node, Python,... theo danh sách định sẵn.
- Nối dây cáp thần kinh (PowerShell Profile) để nạp Alias và Custom Scripts mỗi khi mở Terminal.
- Map AutoHotkey v2 vào Startup của Windows.

### 🌟 2. Các Module Tính Năng Nổi Bật

#### 💻 Đầu não Neovim (`~/.config/nvim`)
Được build bằng **Lua** cực nhẹ và clean, sử dụng `lazy.nvim` làm Plugin Manager.
- **LSP System:** Setup theo API v0.11+ mới nhất, de-bloated (không dùng Mason cho core LSPs) giúp load siêu nhanh. Hỗ trợ Python (Pyright), TS, PHP, Lua.
- **Telescope & Harpoon:** Nhảy file mượt mà như dùng hack.
- **Giao diện:** Tokyonight theme, trong suốt (Transparent background), tích hợp Neo-tree cực ngầu.

#### 🪟 Giao diện Terminal WezTerm (`~/.config/wezterm`)
- Render bằng **WebGpu** cho input latency cực thấp.
- Bố cục vô cực (Integrated Buttons), tắt Tab Bar để tối đa diện tích code.
- Font: *JetBrains Mono* kèm Ligatures.

#### ⚙️ PowerShell Core Scripts (`~/.config/powershell/scripts`)
Vứt bỏ các command dài dòng, xài ngay bộ Alias ngắn gọn được nhúng sẵn:
- `ds` (`dot-sync`): Auto-detect thay đổi, add, tạo commit timestamp và push lên Github trong 1 nốt nhạc.
- `pg-up` / `pg-down`: Buff mana (Start) hoặc cho PostgreSQL đi ngủ để tiết kiệm RAM.
- `y`: Mở siêu trình quản lý file Yazi, tự động nhảy `cd` đến thư mục cuối cùng lúc tắt thay vì dội về chỗ cũ.
- `block-winkey`: Chọc thẳng Registry để khóa/mở khóa các tổ hợp phím Win rườm rà (VD: `block-winkey -keys "DRE"`).

#### ⌨️ Window Manager bằng AutoHotkey (`~/.config/ahk`)
- Lắng nghe sự kiện phím tắt toàn cục.
- `Win + T`: Mở Terminal chuẩn (được fallback an toàn qua Environment Variable `TERMINAL`).
- `Win + Q`: Đóng cửa sổ Active lập tức (`WM_CLOSE`).
- `Win + C`: Trích xuất HWND và căn giữa màn hình mọi cửa sổ (Thuật toán Center siêu chuẩn).
