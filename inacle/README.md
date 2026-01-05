# Inacle App

Inacle client mobile application built with Flutter.

## Prerequisites

Before you begin, ensure you have the following installed on your Mac:

### Required Versions

| Tool | Version | Notes |
|------|---------|-------|
| Flutter | 3.35.6 (stable) | [Install Flutter](https://docs.flutter.dev/get-started/install) |
| Dart | 3.9.2 | Included with Flutter |
| Xcode | 16.4 (Build 16F6) | Install from App Store |
| CocoaPods | 1.16.2 | `sudo gem install cocoapods` |
| iOS Simulator | iOS 18.5+ | Included with Xcode |

### Dart SDK Constraint
```yaml
sdk: '>=3.4.3 <4.0.0'
```

## Installation

### 1. Clone the repository
```bash
git clone https://github.com/vivekin/inacle-app.git
cd inacle-app/inacle
```

### 2. Install Flutter dependencies
```bash
flutter pub get
```

### 3. Install iOS dependencies
```bash
cd ios
pod install
cd ..
```

### 4. Run the app
```bash
# List available devices
flutter devices

# Run on iOS Simulator
flutter run -d "iPhone 16 Pro"

# Run on Android emulator
flutter run -d <android_device_id>
```

## Dependencies

### Main Dependencies
| Package | Version | Purpose |
|---------|---------|---------|
| cupertino_icons | ^1.0.6 | iOS style icons |
| get | ^4.6.6 | State management & navigation |
| http | ^1.2.1 | HTTP requests |
| shared_preferences | ^2.2.3 | Local storage |
| flutter_svg | ^2.0.10+1 | SVG rendering |
| flutter_svg_provider | ^1.0.7 | SVG image provider |
| flutter_screenutil | ^5.9.3 | Responsive UI |
| pin_code_fields | ^8.0.1 | OTP input fields |
| webview_flutter | ^4.8.0 | WebView component |
| data_table_2 | ^2.5.15 | Data tables |
| intl | ^0.19.0 | Internationalization |
| auto_size_text | ^3.0.0 | Auto-sizing text |

### iOS Pods
- Flutter (1.0.0)
- shared_preferences_foundation (0.0.1)
- webview_flutter_wkwebview (0.0.1)

## Project Structure

```
inacle/
├── lib/                    # Dart source code
│   ├── main.dart          # App entry point
│   └── theme.dart         # App theming
├── assets/
│   ├── fonts/             # Custom Roboto fonts
│   └── images/            # Image assets
├── ios/                   # iOS native code
├── android/               # Android native code
└── pubspec.yaml           # Flutter dependencies
```

## Troubleshooting

### Flutter API Compatibility
If you encounter errors like `CardTheme` or `DialogTheme` type mismatches, update them to `CardThemeData` and `DialogThemeData` respectively (Flutter 3.35+ breaking change).

### CocoaPods Issues
```bash
cd ios
pod deintegrate
pod install
```

### Clean Build
```bash
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter run
```

## App Version
- **Version:** 1.1.0+2
