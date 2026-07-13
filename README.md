# Speakify Dashboard

Flutter web admin / instructor dashboard for **Speakify**. Manage students and sections, lessons, quizzes, scores, and rankings. Students use the companion **Speakify** mobile app (SpeechLab).

Firebase project: `speechlab-31612`.

## Roles

| Role | Access |
|------|--------|
| **ADMIN** | Full access, including instructor management |
| **TEACHER** | Own profile, handled sections, content and scores for their sections |

## Features

- **Auth** — Welcome, login, register, password reset
- **Home** — Section student counts, recent activity, active students panel; shortcuts to scores, quizzes, ranking
- **Sections** — Students by section; add/edit students; grant or revoke lesson and quiz access; achievements
- **Instructors** — Admin CRUD for instructors; teachers edit their own profile / handled sections
- **Lessons** — List, add, edit, delete custom lessons
- **Quizzes** — Custom quizzes: list, add, edit, archive
- **Scores** — Quiz and SpeechLab result views
- **Ranking** — Leaderboards for quizzes and SpeechLab levels

## Project structure

```
lib/
  main.dart
  firebase_options.dart
  core/
    di/                     # GetIt modules
    session/                # Auth session (ADMIN / TEACHER)
    errors/
    utils/                  # Routes, theme, responsive_util, toasts
    widgets/                # DashboardShell, nav, shared UI
  features/
    auth/
    home/
    instructors/
    lessons/
    quizzes/
    ranking/
    scores/
    sections/
```

Each feature follows clean architecture:

```
features/<name>/
  data/           # Firebase services, models, repository implementations
  domain/         # Repository contracts, use cases
  presentation/   # Pages, viewmodels (Riverpod), widgets
```

Authenticated screens use `DashboardShell` for consistent chrome and navigation.

## Responsive UI

| Layout | When | Navigation | Active students (home) |
|--------|------|------------|-------------------------|
| **Wide** | Width ≥ 900 and landscape | Left nav rail | Right side panel |
| **Compact** | Width < 900 or portrait | Left drawer (menu) | End drawer (people icon) |

Breakpoints live in `lib/core/utils/responsive_util.dart`.

## Tech stack

| Area | Stack |
|------|--------|
| Framework | Flutter web (SDK `>=3.0.5 <4.0.0`) |
| Backend | Firebase Auth, Cloud Firestore, Firebase Storage |
| State | Riverpod, Hooks Riverpod, Flutter Hooks |
| Routing | GoRouter |
| Architecture | GetIt, dartz, Freezed / JSON codegen |
| UI | Google Fonts, Syncfusion charts, fluttertoast, `dropdown_search`, `image_picker_web` |

## Local setup

### Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) SDK matching `>=3.0.5 <4.0.0`
- Chrome (or another Flutter web target)

### 1. Install dependencies

```bash
cd Speechlab-Dashboard
flutter pub get
```

### 2. Firebase

`lib/firebase_options.dart` is already configured for project `speechlab-31612`. No FlutterFire CLI step is required unless you switch Firebase projects.

### 3. Code generation (optional)

Only needed if you change Freezed / JSON models:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Run locally

```bash
flutter run -d chrome
```

Or:

```bash
flutter run -d web-server --web-port=8080
```

### 5. Local Storage images (CORS)

Profile pictures from Firebase Storage may fail in Chrome on `localhost` even when they work on the deployed Hosting URL. That is a Storage **CORS** issue (not Storage security rules).

From the dashboard repo root (requires [Google Cloud SDK](https://cloud.google.com/sdk) / `gsutil`):

```bash
gsutil cors set cors.json gs://speechlab-31612.appspot.com
```

Then hard-refresh the local app.

## Deploy

Requires the [Firebase CLI](https://firebase.google.com/docs/cli) and login (`firebase login`). Hosting serves `build/web` (see `firebase.json`).

```bash
flutter build web
firebase deploy --only hosting
```
