# Flutter Task Manager 🚀

A modern, feature-rich task management application built with Flutter, designed to enhance productivity with offline and cloud capabilities.

## ✨ Features

- 🎨 **Responsive UI**: Seamless navigation across splash, login, home, and task screens with Lottie animations.
- 📝 **Task CRUD Operations**: Create, read, update, and delete tasks with input fields for title, description, and due date.
- 💾 **Local Persistence**: Offline task storage using `sqflite`.
- 🔥 **Firebase Integration**: Authenticate users and sync local data to Cloud Firestore.
- 🧠 **AI Task Generation**: Generate and prioritize tasks using Gemini API via `google_generative_ai`.
- 🔔 **Local Notifications**: Get reminders 15 minutes before task deadlines.
- 🧭 **Navigation Bar**: Easily access "Add Task" and "Generate Plan" using `go_router`.
- ⚙️ **AppBar Controls**: Includes "Sign Out" and "Sync" buttons.
- ✋ **Gesture Support**: Delete tasks with a right-swipe and confirmation popup.
- 🔑 **Remember Login**: Uses `shared_preferences` to retain login state.
- 📶 **Network Check**: Monitors connectivity via `connectivity_plus`.

## 🖥️ Tech Stack

| Tool | Purpose |
|------|---------|
| **Flutter** | Cross-platform UI framework |
| **Firebase** | Authentication & Cloud Firestore |
| **sqflite** | Local SQLite database |
| **google_generative_ai** | Gemini AI integration |
| **flutter_local_notifications** | Local push notifications |
| **provider** | State management |
| **shared_preferences** | Persistent storage |
| **go_router** | Declarative routing |
| **connectivity_plus** | Network check |
| **lottie** | Animations |

## 📋 Navigation Workflow

```
App Launch 🚀
↓
Splash Screen (Lottie Fade-in)
↓
Authentication Check 🔒
→ If not logged in → Login Screen
→ If logged in → Home Screen
```

### Screens Overview

- 🔑 **Login Screen**: Email/Password or Google Sign-In + "Remember Me"
- 🆕 **Sign Up Page**: Register new user → returns to login
- 🏠 **Home Screen**: Task list, Navigation bar & AppBar actions
- ➕ **Add Task**: Input title, description, due date
- 💡 **Generate Plan**: Generate AI-based task list
- 🔍 **Task Details**: View/edit task
- 🗑️ **Swipe to Delete**: Confirm and remove task
- 🔁 **Sync**: Push local tasks to Firestore
- 🚪 **Sign Out**: Log out unless "Remember Me" is active
- ⏰ **Notifications**: 15-min reminders before deadlines

## 📷 Screenshots

> _Add screenshots here with links or embedded images_

- Splash Screen  
- Login Screen  
- Home Screen  
- Task Details  

## 📦 Dependencies

```yaml
dependencies:
  flutter_lints: ^3.0.0
  firebase_core: ^3.4.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.4
  sqflite: ^2.3.3+1
  google_generative_ai: ^0.4.0
  flutter_local_notifications: ^17.2.3
  provider: ^6.1.2
  shared_preferences: ^2.3.2
  go_router: ^14.2.8
  connectivity_plus: ^6.0.5
  lottie: ^3.1.2
```

## ⚙️ Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/flutter-task-manager.git

# Navigate into the project
cd flutter-task-manager

# Install dependencies
flutter pub get
```

### 🔧 Firebase Setup

1. Create a Firebase project.
2. Enable Authentication and Firestore.
3. Add:
   * `google-services.json` → `android/app/`
   * `GoogleService-Info.plist` → `ios/Runner/`

### 🤖 Gemini API Setup

* Get API key from [Google AI Studio](https://makersuite.google.com/app).
* Add the key to `lib/services/ai_service.dart`.

### ▶️ Run the App

```bash
flutter run
```

## 🔨 Configuration

| File                               | Purpose               |
| ---------------------------------- | --------------------- |
| `lib/config/firebase_options.dart` | Firebase credentials  |
| `lib/services/ai_service.dart`     | Gemini API key        |
| `lib/view/splash_screen.dart`      | Lottie animation path |

## 🏗️ Architecture (MVVM)

```
lib/
├── config/              # Firebase options, Gemini config, API keys, etc.
├── constants/           # App-wide constants (colors, text styles, etc.)
├── model/
│   ├── entities/        # Data models (e.g., TaskEntity)
│   ├── repositories/    # Business logic and app-layer data handling
│   ├── services/        # External data access (e.g., Firebase, Gemini API)
├── routing/             # App route definitions using go_router
├── view/                # UI screens (Splash, Login, Home, AddTask, etc.)
├── viewmodel/           # State management using ChangeNotifier
├── main.dart            # Entry point of the application
```

## 🤝 Contributing

1. Fork the repo
2. Create a branch: `git checkout -b feature-branch`
3. Commit: `git commit -m "Add feature"`
4. Push: `git push origin feature-branch`
5. Submit a Pull Request

## 📜 License

This project is licensed under the [MIT License](LICENSE).

## 📬 Contact

For questions or feedback, reach out to **Sahim Salem** at [sahim.salem@brainstation-23.com](mailto:sahim.salem@brainstation-23.com).