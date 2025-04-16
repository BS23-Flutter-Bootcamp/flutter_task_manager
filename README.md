
# 📝 Flutter Task Manager App

A clean, minimalistic To-Do task management application built with Flutter.  
It follows **MVVM architecture** and supports **CRUD operations** with **local data persistence** using Shared Preferences.

<br>

## 🚀 Features

- ✅ Create, Read, Update, and Delete (CRUD) tasks
- 💾 Persistent data storage using `shared_preferences`
- 🧠 MVVM architectural pattern for clean separation of concerns
- 🖼️ Splash screen with smooth transition
- 📱 Responsive and modern UI
- 🔄 Navigation between screens (Splash → Home → Task Details)
- 🌙 Light theme with clean design aesthetics

<br>

## 📸 Screenshots

| Splash Screen | Home Screen | Add/Edit Task |
|---------------|-------------|----------------|
| ![splash](assets/screenshots/splash.png) | ![home](assets/screenshots/home.png) | ![details](assets/screenshots/details.png) |


<br>

## 🧱 Architecture

The app follows the **MVVM (Model-View-ViewModel)** pattern:

```
lib/
├── model/           # Task model class
├── view_model/      # TaskViewModel for business logic & state
├── view/            # UI screens: Splash, Home, TaskDetails
├── routes/          # Routing setup 
├── widgets/         # Reusable widgets (if any)
└── main.dart        # Entry point
```

- **Model**: Represents the structure of a task
- **ViewModel**: Handles task logic and notifies the UI
- **View**: Displays the UI and reflects ViewModel changes

<br>

## 🛠️ Tech Stack

- **Flutter** 🐦
- **Dart**
- **Provider** (state management)
- **Shared Preferences** (local storage)

<br>

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5
  shared_preferences: ^2.2.2
```

<br>

## 🧪 How to Run

1. **Clone the repository**

```bash
git clone https://github.com/your-username/flutter-todo-app.git
cd flutter-todo-app
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Run the app**

```bash
flutter run
```

> ⚠️ Make sure a simulator or device is connected.

<br>

## 🧼 TODOs / Improvements

- [ ] Add search/filter functionality
- [ ] Dark mode support
- [ ] Task reminder with notifications
- [ ] Firebase sync (optional)

<br>

## 🤝 Contribution

Contributions are welcome!  
Feel free to fork the repo, create a branch, and open a PR.

<br>

