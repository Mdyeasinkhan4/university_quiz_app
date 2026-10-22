# UniQuiz Pro 🎓

A production-grade, enterprise-level **University Quiz Application** built with **Flutter (Material 3)**, featuring a feature-first Clean Architecture, Riverpod state management, and declarative GoRouter navigation.

---

## 🏛️ Architecture & Technical Stack

- **Architecture**: Feature-first Clean Architecture (Domain, Data, and Presentation layers separated per feature).
- **State Management**: Flutter Riverpod (`StateNotifierProvider`, `Provider.family`) for structured, testable state management.
- **Routing & Navigation**: GoRouter with declarative routing and reactive route guards for role-based access control (Student / Faculty).
- **Styling & Theming**: Material 3 design system with custom `ThemeExtension` supporting both Light and Dark modes, styled with Google Fonts (`Inter`).
- **Data & Mock Layer**: Plain Dart model classes with `fromJson`/`toJson` serialization and robust mock repositories simulating network latencies and error handling.

---

## 📂 Project Folder Structure

```text
lib/
├── app/
│   ├── config/ (routes, theme, app_constants)
│   └── app.dart
├── core/
│   ├── constants/ (api_endpoints_placeholder, asset_paths, app_colors)
│   ├── network/ (mock_client, error_handling_base)
│   ├── utils/ (validators, formatters, date_time_helpers)
│   └── widgets/ (custom_button, custom_text_field, loading_shimmer, error_view)
└── features/
    ├── auth/
    │   ├── data/ (models, mock_auth_repository)
    │   ├── domain/ (entities, repository_interfaces)
    │   └── presentation/ (screens: login_screen, register_screen; controllers, widgets)
    ├── dashboard/
    │   └── presentation/ (screens: student_dashboard, teacher_dashboard)
    ├── course/
    │   ├── data/ (models: course_model, mock_course_repo)
    │   └── presentation/ (screens: course_details_screen, enrolled_courses_screen)
    ├── quiz_attempt/ (Student Exam Flow)
    │   ├── data/ (models: question_model, quiz_model, attempt_model)
    │   └── presentation/ 
    │       ├── controllers/ (quiz_timer_controller, quiz_state_notifier)
    │       ├── screens/ (quiz_lobby_screen, active_quiz_screen, quiz_result_screen)
    │       └── widgets/ (question_card, timer_widget, option_selector, submit_dialog)
    └── quiz_management/ (Teacher Flow)
        └── presentation/ (screens: create_quiz_screen, add_question_screen, student_results_screen)
```

---

## 🌟 Key Features & Flows

### 1. Authentication & Role Switcher
- Support for both **Student** and **Faculty** roles.
- Input validation for university email, password, student ID, and department selection.

### 2. Student Dashboard & Course Hub
- Quick academic statistics (GPA, completed tests, enrolled courses).
- Active examination banner with time remaining countdowns.
- Enrolled courses list with syllabus expansion and progress indicators.

### 3. Live Quiz Examination Environment
- **Sticky Top Bar**: Real-time countdown timer with warning states, question progress indicator, and question palette grid drawer.
- **Question Display**: Supports Markdown-like code snippet containers and smooth animated single/multiple choice selectors.
- **Mock Anti-Cheat Overlay**: App lifecycle listener (`WidgetsBindingObserver`) that detects app minimization or screen blur, logging warnings and incidents.

### 4. Quiz Result & Review Screen
- Total score card with percentage calculation and pass/fail badges.
- Correct vs. incorrect breakdown statistics.
- Comprehensive question-by-question review view with correct answers and explanations.

### 5. Faculty Quiz Management & Creation
- Form for quiz title, course selection, duration, and negative marking toggle.
- Dynamic question addition list with option selection and correct answer configuration.
- Student submission results viewer.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (`^3.13.4` or higher)
- Dart SDK

### Installation & Execution
1. Clone the repository and navigate to the project directory:
   ```bash
   cd university_quiz_app
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run tests:
   ```bash
   flutter test
   ```
4. Run the application:
   ```bash
   flutter run
   ```
