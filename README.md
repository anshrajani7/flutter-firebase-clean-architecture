# 📱 Flutter Firebase Clean Architecture App

A Flutter application implementing Clean Architecture with Firebase integration, featuring authentication and real-time data synchronization.

---

## 📋 Table of Contents
1. Architecture
2. Features
3. Project Structure
4. Setup
5. Dependencies
6. Usage
7. Testing
8. Theme Customization
9. License and Author

---

## 🏗 Architecture

This project follows **Clean Architecture** principles with 3 main layers:

### 1. Presentation Layer
- **Widgets**: UI components
- **Pages**: Full screens
- **Bloc**: State management
    - Events
    - States
    - Bloc classes

### 2. Domain Layer
- **Entities**: Core business objects
- **Repositories**: Abstract definition of data operations
- **Usecases**: Business logic units

### 3. Data Layer
- **Models**: Data objects implementing entities
- **Repositories**: Concrete implementations
- **Datasources**: Remote and local data handling

---

## ✨ Features

### Authentication
- Email/Password Sign In
- User Registration
- Profile Management
- Real-time Auth State

### Tab Data Management
- Real-time Data Sync
- Offline Support
- Data Caching
- Pull-to-Refresh

### UI/UX
- Material Design 3
- Dark/Light Theme
- Responsive Layout
- Error Handling
- Loading States

---

## 📁 Project Structure
````
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   └── network_info.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
│       └── date_formatter.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
│   └── tabs/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── injection_container.dart
└── main.dart
````
---

## 🚀 Setup

### Firebase Setup
1. **Install Firebase CLI**:
    ```bash
    npm install -g firebase-tools
    ```

2. **Login to Firebase**:
    ```bash
    firebase login
    ```

3. **Initialize Firebase**:
    ```bash
    flutterfire configure
    ```

### Project Configuration
1. **Clone the repository**:
    ```bash
    git clone <repository-url>
    ```

2. **Install dependencies**:
    ```bash
    flutter pub get
    ```

3. **Run the app**:
    ```bash
    flutter run
    ```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Firebase
  firebase_core: ^2.7.0
  firebase_auth: ^6.2.0
  cloud_firestore: ^4.4.0

  # State Management
  flutter_bloc: ^8.1.3

  # Dependency Injection
  get_it: ^7.6.0

  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # Utils
  dartz: ^0.10.1
  equatable: ^2.0.1
  intl: ^0.18.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.6
  hive_generator: ^2.0.1
````
▶️ Usage

To run the app:
```bash
flutter run
```

🧪 Testing
Unit Tests
```bash
flutter test test/unit/
```
Integration Tests
```bash
flutter test test/integration/
```

🎨 Theme Customization

	•	Themes: lib/core/theme/app_theme.dart
	•	Colors: lib/core/theme/app_theme.dart
	•	Typography: lib/core/theme/app_theme.dart


👨‍💻 License and Author

Author: Ansh Rajani
Email: anshrajani007@gmail.com
LinkedIn: linkedin.com/in/ansh-rajani-b4b1b01b3
GitHub: github.com/anshrajani7

License: MIT License
