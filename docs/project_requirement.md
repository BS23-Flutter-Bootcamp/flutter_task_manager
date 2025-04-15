# To-Do App Requirement Planning Document

## Project Details
- **Project Name:** To-Do App
- **Duration:** 1 Week (April 10–April 16, 2025)
- **Total Effort:** 40 hours
- **Developer:** Sahim Salem
- **Date Created:** April 10, 2025

---

## Project Overview
The To-Do App is a mobile application built with Flutter to manage tasks efficiently. It will feature full CRUD functionality, persistent local storage using Shared Preferences, and a clean MVVM architecture. The app will include a splash screen and multi-page navigation for adding/editing tasks, with medium effort allocated to a functional and user-friendly UI.

---

## Requirements

### Functional Requirements
#### Task Management (CRUD):
- **Create:** Users can add new tasks with a title (required), description (optional), and status (completed/incomplete).
- **Read:** Display a list of all tasks on the home screen.
- **Update:** Edit existing task details (title, description, status).
- **Delete:** Remove a task from the list.

#### Navigation:
- **Multi-page navigation** with separate screens for:
  - Splash Screen (initial load).
  - Home Screen (task list).
  - Task Details Screen (add/edit tasks).

#### Splash Screen:
- Display a simple splash screen with a logo or app name for 2–3 seconds before redirecting to the Home Screen.

### Non-Functional Requirements
#### Performance:
- Apps must load and display tasks within 2 seconds on average devices.
- CRUD operations should be completed in under 1 second.

#### Usability:
- Intuitive UI with clear actions (e.g., buttons for add, edit, delete).
- Consistent design across screens (medium effort on UI).

#### Maintainability:
- Codebase must follow MVVM best practices for scalability and readability.
- Separation of concerns between UI, logic, and data.

#### Reliability:
- Data persistence must ensure no task loss unless explicitly deleted by the user.

#### Portability:
- App should run on both Android and iOS via Flutter’s cross-platform capabilities.

---

## Technical Requirements

### Framework & Language:
- Flutter (Dart) for cross-platform development.

### Data Persistence:
- Use Shared Preferences to store tasks locally as JSON-encoded strings.

### Architecture:
- **MVVM Pattern:**
  - **Model:** Task class and persistence logic.
  - **ViewModel:** TaskViewModel for business logic and state management.
  - **View:** UI screens (Splash, Home, Task Details).

### Dependencies:
- `shared_preferences: ^2.0.0` for local storage.
- Optional: `provider` or `get` for state management within MVVM.

### Navigation:
- Flutter Navigator 2.0 or basic push/pop for multi-page flow.

### UI Design:
- Medium effort: Functional design with basic theming (e.g., colors, fonts) and minimal animations.

---

## Effort Breakdown
- **Total Hours:** 40
  - **UI Design (Medium Effort, ~20%):** 8 hours
  - **Backend Logic & Persistence:** 14 hours
  - **Architecture Setup (MVVM):** 10 hours
  - **Testing & Refinement:** 8 hours

---

## Weekly Schedule

### Day 1: Setup & MVVM Architecture (8 hours)
#### Tasks:
- Initialize Flutter project with dependencies (`shared_preferences`).
- Define MVVM structure:
  - **Model:** Task class (title, description, status).
  - **ViewModel:** TaskViewModel with initial CRUD stubs.
  - **View:** Basic screen placeholders.
- Set up navigation (Splash → Home → Task Details).

**Deliverable:** Project skeleton with MVVM and navigation.

---

### Day 2: UI – Splash & Home Screen (8 hours)
#### Tasks:
- **Splash Screen (3 hours):**
  - Simple logo/text with fade-in effect.
  - Auto-redirect to Home after delay.
- **Home Screen (5 hours):**
  - ListView of tasks (title, status checkbox).
  - Add button (navigates to Task Details).

**Deliverable:** Functional Splash and Home screens.

---

### Day 3: UI – Task Details & Navigation (8 hours)
#### Tasks:
- **Task Details Screen (6 hours):**
  - Form with title, description, and save/delete buttons.
  - Navigation to return to Home.
- **Polish navigation (2 hours):**
  - Smooth transitions (e.g., slide effect).

**Deliverable:** Task Details screen and complete navigation flow.

---

### Day 4: Data Persistence & CRUD Logic (8 hours)
#### Tasks:
- **Integrate Shared Preferences:**
  - Implement CRUD in TaskViewModel:
    - **Create:** Add task with unique ID.
    - **Read:** Fetch and expose task list.
    - **Update:** Modify task by ID.
    - **Delete:** Remove task by ID.

**Deliverable:** Working CRUD with persistent storage.

---

### Day 5: Testing & Finalization (8 hours)
#### Tasks:
- **Functional testing (4 hours):**
  - Verify CRUD operations and persistence.
  - Test navigation flow and edge cases (e.g., empty list).
- **UI refinement (2 hours):**
  - Apply basic theme (e.g., blue primary color, Roboto font).
- **Code cleanup (2 hours):**
  - Ensure MVVM adherence and remove unused code.

**Deliverable:** Fully tested, functional To-Do App.

---

## Technical Details

### File Structure:
- `lib/models/task.dart`
- `lib/viewmodels/task_viewmodel.dart`
- `lib/views/splash_screen.dart`, `home_screen.dart`, `task_details_screen.dart`

### Storage Format:
- JSON list of tasks.

### UI Guidelines:
- **Primary color:** Blue (#2196F3).
- **Font:** Roboto (via Google Fonts).
- **Minimal animations:** (e.g., fade for Splash).

---

## Assumptions
- You have experience with Flutter/Dart.
- No advanced features (e.g., due dates, notifications) to fit the 1-week scope.
- Medium UI effort focuses on functionality over aesthetics.

---

## Risks & Mitigations
- **Risk:** Persistence logic delays CRUD implementation.
  - **Mitigation:** Start with in-memory list, then integrate Shared Preferences.
- **Risk:** MVVM setup takes longer than expected.
  - **Mitigation:** Use a lightweight state management solution (e.g., `provider`) if needed.

---

## Success Criteria
- App launches with a splash screen and navigates to Home.
- Users can create, read, update, and delete tasks with persistent data.
- MVVM architecture is strictly followed (clear separation of concerns).
- UI is functional and usable with medium effort applied.
- Multi-page navigation works seamlessly for task management.