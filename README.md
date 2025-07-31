# FoodCal - Ứng dụng Theo dõi Dinh dưỡng

## 📱 Giới thiệu

FoodCal là ứng dụng iOS giúp người dùng theo dõi lượng calo và dinh dưỡng hàng ngày thông qua việc quét và nhận dạng thực phẩm bằng camera. Ứng dụng sử dụng Machine Learning để nhận diện món ăn và cung cấp thông tin dinh dưỡng chi tiết.

## ✨ Tính năng chính

- **Quét thực phẩm**: Nhận dạng món ăn qua camera sử dụng Core ML
- **Tìm kiếm thủ công**: Tìm kiếm thực phẩm trong cơ sở dữ liệu
- **Thông tin dinh dưỡng**: Hiển thị chi tiết calo, protein, carbs, fat
- **Lịch sử**: Theo dõi các bữa ăn hàng ngày
- **Mục tiêu cá nhân**: Đặt và theo dõi mục tiêu dinh dưỡng
- **Biểu đồ trực quan**: Xem tiến trình qua các biểu đồ
- **Dark mode**: Hỗ trợ giao diện tối

## 📂 Cấu trúc dự án

```
FoodCal/
├── FoodCal.xcodeproj
├── FoodCal/
│   ├── App/
│   │   └── FoodCalApp.swift              # Entry point của ứng dụng
│   │
│   ├── Models/
│   │   ├── Food.swift                    # Model thực phẩm
│   │   ├── Nutrition.swift               # Model thông tin dinh dưỡng
│   │   ├── FoodHistory.swift             # Model lịch sử
│   │   └── User.swift                    # Model người dùng
│   │
│   ├── Views/
│   │   ├── MainTabView.swift             # Tab navigation chính
│   │   ├── Home/
│   │   │   └── HomeView.swift            # Màn hình trang chủ
│   │   ├── Scanner/
│   │   │   ├── CameraScannerView.swift   # Màn hình quét camera
│   │   │   └── ScanResultView.swift      # Kết quả quét
│   │   ├── Profile/
│   │   │   ├── ProfileView.swift         # Thông tin cá nhân
│   │   │   └── SettingsView.swift        # Cài đặt ứng dụng
│   │   └── Components/
│   │       ├── FoodCard.swift            # Card hiển thị thực phẩm
│   │       ├── NutritionChart.swift      # Biểu đồ dinh dưỡng
│   │       └── LoadingView.swift         # Loading indicator
│   │
│   ├── ViewModels/
│   │   ├── HomeViewModel.swift           # Logic màn hình home
│   │   ├── ScannerViewModel.swift        # Logic xử lý quét
│   │   └── ProfileViewModel.swift        # Logic profile
│   │
│   ├── Services/
│   │   ├── NetworkService.swift          # Base networking
│   │   ├── NutritionAPIService.swift     # API dinh dưỡng
│   │   ├── CameraService.swift           # Xử lý camera
│   │   ├── MLService.swift               # Machine Learning service
│   │   └── DataManager.swift             # Quản lý dữ liệu local
│   │
│   ├── Utils/
│   │   ├── Constants.swift               # Hằng số ứng dụng
│   │   ├── Extensions.swift              # Swift extensions
│   │   └── Helpers.swift                 # Helper functions
│   │
│   ├── Resources/
│   │   ├── Assets.xcassets/              # Images, colors, icons
│   │   ├── LaunchScreen.storyboard       # Launch screen
│   │   └── Info.plist                    # App configuration
│   │
│   └── ML Models/
│       └── FoodDetection.mlmodel         # Core ML model
│
├── README.md
└── .gitignore
```

## 🚀 Cài đặt và Chạy

### Yêu cầu
- Xcode 14.0+
- iOS 15.0+
- macOS Monterey hoặc mới hơn

### Các bước cài đặt

1. Clone repository
```bash
git clone https://github.com/yourusername/FoodCal.git
cd FoodCal
```

2. Mở project trong Xcode
```bash
open FoodCal.xcodeproj
```

3. Chọn simulator hoặc device
4. Build và chạy (⌘ + R)

## 📸 Screenshots

<p align="center">
  <img src="Resources/screenshots/home.png" width="200" alt="Home Screen">
  <img src="Resources/screenshots/scanner.png" width="200" alt="Scanner">
  <img src="Resources/screenshots/result.png" width="200" alt="Result">
  <img src="Resources/screenshots/profile.png" width="200" alt="Profile">
</p>

## 🔑 API Keys

Ứng dụng sử dụng API dinh dưỡng. Bạn cần đăng ký và lấy API key từ:
- [Spoonacular API](https://spoonacular.com/food-api)
- Hoặc [Edamam API](https://www.edamam.com/)

Thêm API key vào `Constants.swift`:
```swift
struct APIConstants {
    static let nutritionAPIKey = "YOUR_API_KEY_HERE"
}
```

## 🤝 Đóng góp

Đây là project cá nhân nhưng mọi đóng góp đều được chào đón!

1. Fork project
2. Tạo feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Mở Pull Request
   
## 📧 Liên hệ

- Email: atdevv2311@gmail.com

<p align="center">Made with ❤️ in Vietnam</p>
