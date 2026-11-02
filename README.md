# KidsvsParent
# kids_vs_parents
Grow Together is an Android-first Flutter prototype for children and parents.

## Run and test

Flutter and Dart are required. The initial prototype uses Flutter SDK packages only.

```powershell
flutter pub get --offline
flutter analyze --no-pub
flutter test --no-pub
flutter run --no-pub
```

Build an ARM64 debug APK:

```powershell
flutter build apk --debug --no-pub --target-platform android-arm64
```

The APK is written to `build/app/outputs/flutter-apk/app-debug.apk`.

## Current prototype scope

- Home dashboard and parent/kids navigation modes.
- Parenting topic reflections with short scored quizzes.
- Learning cards for dictionary, Thirukkural, letter tracing, drawing, stories, coding, puzzles, science lessons, and India/state history.
- Six science mini-lessons with animated concept diagrams, twelve built-in science questions, and path-specific daily quizzes that rotate by date.
- Nine learning paths have stable IDs; Parent space manages a single path-wise CSV library saved only in the app's private on-device files.
- Local drawing/letter canvas, optional system click/haptic feedback, settings, and a parent-directed contact form.
- The assistant uses fixed local example responses. Live AI, voice, accounts, remote contact delivery, learning-progress persistence, and parent verification are not connected.

## Manage learning questions

In Parent space, use **Import learning CSV**. An import replaces the previous local question library; the Learn page has no admin controls. Each question needs a unique `question_id` and a `path_id` matching one of the app's learning paths: `dictionary`, `thirukkural`, `letter_tracing`, `drawing`, `stories`, `coding`, `puzzles`, `science`, or `india_history`. The Parent page lists the accepted IDs. Use the example at [examples/learning_questions.csv](examples/learning_questions.csv), which includes two questions for each path.

Required columns are `question_id`, `path_id`, `question`, `option1`, `option2`, and `answer`. `option3`, `option4`, and `explanation` are optional. IDs must be unique, and unknown path IDs are rejected. The `answer` value can be the exact option text or a 1-based option number. CSV headers are case-insensitive; quoted commas and escaped quotes are supported. Files are limited to 1 MB. Each daily quiz selects up to five questions from that path's built-in and imported questions, based on the local date.

The app is not release-ready. Configure authenticated package access through Motorola Solutions Curation before adding hosted dependencies; review the team setup guide at https://confluence.mot-solutions.com/spaces/ARTIFACT/pages/1225147372/Curation. Production work still needs parent consent and gated controls, secure storage/backend rules, reviewed localized content, assistant moderation, data lifecycle flows, release signing, and child-safety/store-policy review.

The default multi-ABI debug build currently fails in the `armeabi-v7a` CMake task; the x86_64-targeted debug build succeeds. The app was exercised on an Android 14 x86_64 emulator, including CSV import and persistence after relaunch.
