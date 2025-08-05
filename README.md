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
│   │   └── FoodCalApp.swift              
│   │
│   ├── Models/
│   │   ├── Food.swift                    
│   │   ├── Nutrition.swift               
│   │   ├── FoodHistory.swift             
│   │   └── User.swift                   
│   │
│   ├── Views/
│   │   ├── MainTabView.swift             
│   │   ├── Home/
│   │   │   └── HomeView.swift           
│   │   ├── Scanner/
│   │   │   ├── CameraScannerView.swift   
│   │   │   └── ScanResultView.swift      
│   │   ├── Profile/
│   │   │   ├── ProfileView.swift         
│   │   │   └── SettingsView.swift        
│   │   └── Components/
│   │       ├── FoodCard.swift            
│   │       ├── NutritionChart.swift      
│   │       └── LoadingView.swift         
│   │
│   ├── ViewModels/
│   │   ├── HomeViewModel.swift           
│   │   ├── ScannerViewModel.swift        
│   │   └── ProfileViewModel.swift        
│   │
│   ├── Services/
│   │   ├── NetworkService.swift          
│   │   ├── NutritionAPIService.swift     
│   │   ├── CameraService.swift           
│   │   ├── MLService.swift               
│   │   └── DataManager.swift            
│   │
│   ├── Utils/
│   │   ├── Constants.swift              
│   │   ├── Extensions.swift              
│   │   └── Helpers.swift                 
│   │
│   ├── Resources/
│   │   ├── Assets.xcassets/              
│   │   ├── LaunchScreen.storyboard       
│   │   └── Info.plist                    
│   │
│   └── ML Models/
│       └── FoodDetection.mlmodel        
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

3. Chọn simulator là máy thật của bạn
4. Build và chạy (⌘ + R)

## 📸 Screenshots

<p align="center">
  <img src="Resources/screenshots/home.png" width="200" alt="Home Screen">
  <img src="Resources/screenshots/scanner.png" width="200" alt="Scanner">
  <img src="Resources/screenshots/result.png" width="200" alt="Result">
  <img src="Resources/screenshots/profile.png" width="200" alt="Profile">
</p>

## 🤝 Đóng góp

Đây là project cá nhân nhưng mọi đóng góp đều được chào đón!

1. Fork project
2. Tạo feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Mở Pull Request
   
<p align="center">--- Made with ❤️ in Vietnam ---</p>
