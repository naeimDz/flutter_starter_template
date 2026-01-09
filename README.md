# Flutter Starter Template - Pro MVC Boilerplate

A **premium Flutter boilerplate** with MVC architecture, designed to give you a robust foundation for building scalable, maintainable applications.

![Flutter](https://img.shields.io/badge/Flutter-3.5+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.5+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## ✨ Features

- **🎨 Dynamic Theming** - Light/Dark mode with persistence
- **🌍 Localization** - Multi-language support (EN/AR) with easy_localization
- **✨ Premium UI/UX** - High-fidelity Auth scenes with Hero animations
- **🏗️ MVC Architecture** - Clean separation of concerns
- **🌐 Networking** - Dio-based API service with interceptors
- **💉 Dependency Injection** - get_it service locator
- **📦 State Management** - Provider pattern
- **🔐 Secure Storage** - SharedPreferences wrapper
- **✅ Form Validation** - Composable validators
- **🎯 Extensions** - Useful Dart extensions for common operations

## 📁 Project Structure

```
lib/
├── main.dart                      # App entry point
│
├── core/                          # Core utilities & config
│   ├── config/                    # Environment & API config
│   │   ├── app_config.dart        # Environment settings
│   │   └── api_endpoints.dart     # API endpoint constants
│   ├── constants/                 # App constants
│   │   ├── app_colors.dart        # Color palette
│   │   ├── app_sizes.dart         # Spacing & sizing
│   │   └── app_strings.dart       # String constants
│   ├── di/                        # Dependency injection
│   │   └── service_locator.dart   # get_it setup
│   ├── routes/                    # App routing
│   │   └── routes.dart            # Route definitions
│   ├── theme/                     # Theme configuration
│   │   ├── app_theme.dart         # Light/Dark themes
│   │   └── app_text_styles.dart   # Typography
│   └── utils/                     # Utility classes
│       ├── extensions.dart        # Dart extensions
│       ├── logger.dart            # Custom logger
│       └── validators.dart        # Form validators
│
├── data/                          # Data Layer (Model)
│   ├── models/                    # Data models
│   │   └── user_model.dart        # Example model
│   ├── repositories/              # Repository pattern
│   │   └── user_repository.dart   # User data operations
│   └── services/                  # External services
│       ├── api_service.dart       # HTTP client
│       └── storage_service.dart   # Local storage
│
├── controllers/                   # Controller Layer
│   ├── base_controller.dart       # Base controller
│   └── home_controller.dart       # Home screen controller
│
├── views/                         # View Layer (Screens)
│   ├── home/
│   │   └── home_view.dart         # Home screen
│   ├── splash/
│   │   └── splash_view.dart       # Splash screen
│   └── error/
│       └── error_view.dart        # Error screens
│
├── providers/                     # State Management
│   ├── theme_provider.dart        # Theme state
│   └── locale_provider.dart       # Language state
│
└── shared/                        # Shared Components
    ├── widgets/                   # Reusable widgets
    │   ├── custom_button.dart     # Custom button
    │   ├── loading_overlay.dart   # Loading overlay
    │   ├── app_text_field.dart    # Text input
    │   └── empty_state.dart       # Empty state
    └── helpers/                   # Helper utilities
        ├── snackbar_helper.dart   # Snackbar utility
        └── dialog_helper.dart     # Dialog utility
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.5+
- Dart SDK 3.5+

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/naeimDz/flutter_starter_template.git
cd flutter_starter_template
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

### Authentication System (Flexible & Plug-n-Play)

The template features a **swappable authentication system** designed to keep getting started effortless while offering production readiness.

- **Option A: Mock Mode (Default)**
  - Works out-of-the-box.
  - No configuration needed.
  - Simulates API calls and returns dummy data.
  - Perfect for UI development and prototyping.

- **Option B: Firebase Mode**
  - Production-ready `firebase_auth` implementation.
  - Enabled via a simple flag.
  
**How to enable Firebase:**
1. Add `google-services.json` (Android) / `GoogleService-Info.plist` (iOS).
2. Set `enableFirebase = true` in `lib/core/config/app_config.dart`.
3. That's it! The app now uses real Firebase Auth.

---

### Environment Configuration

Use `--dart-define` to set environment:

```bash
# Development (default)
flutter run

# Staging
flutter run --dart-define=ENV=staging

# Production
flutter run --dart-define=ENV=prod
```

## 📖 Usage Examples

### API Service
```dart
// Get instance via service locator
final apiService = sl<ApiService>();

// Make API calls
final result = await apiService.get<UserModel>(
  '/users/me',
  fromJson: (data) => UserModel.fromJson(data),
);

if (result.isSuccess) {
  print(result.data);
} else {
  print(result.error);
}
```

### Form Validation
```dart
TextFormField(
  validator: Validators.compose([
    Validators.required(),
    Validators.email(),
  ]),
)
```

### Extensions
```dart
// String extensions
'hello world'.capitalize  // 'Hello world'
'test@email.com'.isEmail  // true

// DateTime extensions
DateTime.now().formatShort  // 'Jan 8, 2025'
DateTime.now().timeAgo      // '5 minutes ago'

// Context extensions
context.screenWidth
context.isDarkMode
context.showSnackBar('Message')
```

### Dialog Helper
```dart
// Show confirmation
final confirmed = await DialogHelper.showConfirm(
  title: 'Delete Item',
  message: 'Are you sure?',
  isDangerous: true,
);

// Show loading
DialogHelper.showLoading(message: 'Please wait...');
// ... do work
DialogHelper.hideLoading();
```

## 🎯 MVC Pattern

This boilerplate follows the **Model-View-Controller (MVC)** pattern:

| Layer | Location | Responsibility |
|-------|----------|----------------|
| **Model** | `data/` | Data models, repositories, services |
| **View** | `views/` | UI screens and widgets |
| **Controller** | `controllers/` | Business logic and state |

### Controller Example
```dart
class HomeController extends BaseController {
  final UserRepository userRepository;
  
  HomeController({required this.userRepository});
  
  UserModel? _user;
  UserModel? get user => _user;
  
  Future<void> loadUser() async {
    await executeAsync(() async {
      final result = await userRepository.getProfile();
      if (result.isSuccess) {
        _user = result.data;
      }
    });
  }
}
```

## 📦 Dependencies

| Package | Purpose |
|---------|---------|
| `provider` | State management |
| `easy_localization` | Internationalization |
| `dio` | HTTP client |
| `get_it` | Dependency injection |
| `shared_preferences` | Local storage |
| `equatable` | Value equality |
| `intl` | Date/number formatting |
| `flutter_svg` | SVG support |
| `cached_network_image` | Image caching |

## 🗺️ Roadmap

We are constantly improving the Pro MVC Boilerplate. Here's what's coming next:

- [x] **Phase 1: Foundation**
  - [x] Core Architecture (MVC)
  - [x] Dynamic Theming & Localization
  - [x] Networking & Storage Services

- [x] **Phase 2: Authentication**
  - [x] Flexible Repository Pattern (Mock/Firebase)
  - [x] Premium Login & Register UI
  - [x] Auth State Management

- [ ] **Phase 3: Advanced Features (Upcoming)**
  - [ ] 💳 Payment Gateway Integration (Stripe)
  - [ ] 🔔 Push Notifications Service
  - [ ] 📊 Analytics Dashboard
  - [ ] 🤖 AI Chat Integration Example

- [ ] **Phase 4: Dev Ops**
  - [ ] 🚀 CI/CD Pipeline (GitHub Actions)
  - [ ] 🧪 Integration Testing Setup
  - [ ] 🐳 Docker Containerization

## 📸 Screenshots

| Light Mode | Dark Mode |
|------------|-----------|
| ![Login Light](/assets/screenshots/login_light.png) | ![Login Dark](/assets/screenshots/login_dark.png) |
| ![Home Light](/assets/screenshots/home_light.png) | ![Home Dark](/assets/screenshots/home_dark.png) |

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Made with ❤️ using Flutter
