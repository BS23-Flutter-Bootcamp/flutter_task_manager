Flutter Task Manager :rocket:
A modern, feature-rich task management application built with Flutter, designed to enhance productivity with offline and cloud capabilities.
:sparkles: Features

Responsive UI :art: Seamlessly navigate across splash, login, home, and task screens with Lottie animations.
Task CRUD Operations :pencil: Effortlessly create, read, update, and delete tasks with input fields for title, description, due date.
Local Persistence :floppy_disk: Store tasks offline using the sqflite Flutter package.
Firebase Integration :fire: Authenticate users and sync local data to Cloud Firestore.
AI Task Generation :brain: Generate and prioritize tasks using the google_generative_ai Flutter package for Gemini API.
Local Notifications :bell: Receive timely reminders 15 minutes before task deadlines with the flutter_local_notifications Flutter package.
Navigation Bar :compass: Easily access "Add Task" and "Generate Plan" features with the go_router Flutter package.
AppBar Controls :gear: Convenient "Sign Out" and "Sync" buttons.
Gesture Support :hand: Delete tasks with a right-swipe and confirmation popup.
Remember Login :key: Use the shared_preferences Flutter package to retain login state.
Network Check :signal_strength: Monitor connectivity with the connectivity_plus Flutter package.

:computer: Tech Stack

Flutter :flutter: Cross-platform framework for iOS and Android.
Firebase :fire: Handles authentication and Cloud Firestore syncing.
sqflite :floppy_disk: Local database for offline task storage.
google_generative_ai :brain: Integrates Gemini AI for task generation.
flutter_local_notifications :bell: Manages local push notifications.
provider :package: State management for real-time UI updates.
shared_preferences :key: Manages "Remember Me" login feature.
go_router :compass: Implements navigation with a clean routing system.
connectivity_plus :signal_strength: Checks network connectivity status.
lottie :movie_camera: Adds engaging animations to the UI.

:clipboard: Navigation Workflow

App Launch :rocket: → Displays Splash Screen with logo and Lottie fade-in animation.
Authentication Check :lock: → If not logged in, navigates to Login Screen; otherwise, proceeds to Home Screen.
Login Screen :door: → User enters Email/Password or selects Google Sign-In with "Remember Me" option, then proceeds to Home Screen.  
Sign Up Link :new: → Redirects to Sign Up Page, then back to Login Screen.


Sign Up Page :pencil2: → User enters Email, Password, and Confirm Password, submits to create account, then returns to Login Screen after successful sign-up.
Home Screen :house: → Shows task list, Navigation Bar ("Add Task", "Generate Plan"), and AppBar Controls ("Sign Out", "Sync").  
Add Task :heavy_plus_sign: → Navigates to Add TaskDetails Screen; user inputs title, description, due date, saves, and returns to Home Screen.  
Generate Plan :bulb: → Initiates AI Task Generation, displays AI-generated list of tasks with title, description, due date, and complete status, navigates to Task Details Screen on save, then returns to Home Screen.  
Tap Task :mag: → Navigates to Task Details Screen for viewing/editing.  
Right-Swipe Task :wastebasket: → Shows deletion confirmation popup, returns to Home Screen on confirmation.  
Sync Button :arrows_counterclockwise: → Syncs locally saved data from Sqflite to Cloud Firestore, remains on Home Screen.  
Sign Out Button :wave: → Logs out, returns to Login Screen unless "Remember Me" is enabled.


Task Details Screen :page_facing_up: → Enables editing or deleting tasks with "Edit" and "Delete" buttons, saves changes, and returns to Home Screen.
Local Notifications :alarm_clock: → Triggers 15 minutes before task deadlines, displays in system tray, no navigation change.

:camera: Screenshots



Splash Screen
Login Screen
Home Screen
Task Details









:package: Dependencies

flutter_lints: ^3.0.0 - Linting for code quality.
firebase_core: ^3.4.0 - Firebase core functionality.
firebase_auth: ^5.3.1 - Firebase authentication.
cloud_firestore: ^5.4.4 - Cloud Firestore for syncing.
sqflite: ^2.3.3+1 - Local SQLite database.
google_generative_ai: ^0.4.0 - Gemini AI integration.
flutter_local_notifications: ^17.2.3 - Local notifications.
provider: ^6.1.2 - State management.
shared_preferences: ^2.3.2 - Persistent key-value storage.
go_router: ^14.2.8 - Navigation and routing.
connectivity_plus: ^6.0.5 - Network connectivity check.
lottie: ^3.1.2 - Lottie animations.

:gear: Installation

Clone the repository:  git clone https://github.com/yourusername/flutter-task-manager.git


Navigate to the project directory:  cd flutter-task-manager


Install dependencies:  flutter pub get


Set up Firebase:  
Create a Firebase project and enable Authentication and Cloud Firestore.
Add google-services.json (Android) and GoogleService-Info.plist (iOS) to the respective directories.


Configure Gemini API:  
Obtain an API key from Google AI Studio and add it to lib/services/ai_service.dart.


Run the app:  flutter run



:wrench: Configuration

Configure Firebase credentials in lib/config/firebase_options.dart.
Update Gemini API key in lib/services/ai_service.dart.
Adjust Lottie animation paths in lib/view/splash_screen.dart.

:building_construction: Architecture
The app follows the MVVM (Model-View-ViewModel) pattern:
lib/
├── model/             # Repository (business logic), service (requests for data from external sources)
├── view_model/        # For state management
├── view/              # UI screens: Splash, Home, Login, Sign Up, Add, Edit, Generate Task
├── routing/           # Routing setup
├── widgets/           # Reusable widgets (if any)
└── main.dart          # Entry point

:handshake: Contributing

Fork the repository.
Create a new branch: git checkout -b feature-branch.
Commit changes: git commit -m "Add new feature".
Push to the branch: git push origin feature-branch.
Submit a pull request.

:scroll: License
This project is licensed under the MIT License. See the LICENSE file for details.
:mailbox: Contact
For questions or feedback, reach out to Sahim Salem at [your-email@example.com].
