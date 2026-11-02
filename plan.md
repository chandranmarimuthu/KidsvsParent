## Plan: Kids and Parents Learning App

Build a polished Android app for children ages 5-12 and their parents in India. Recommend Flutter for the visual, audio-rich experience, with English and Tamil at launch and an extensible localization/content model. Ship parenting assessments, child learning activities, and a parent-controlled AI assistant with push-to-talk voice; protect child privacy by design and keep core learning usable offline.

**Steps**
1. **Foundation and product decisions:** Scaffold Flutter/Dart with feature-first modules, Riverpod state management, `go_router`, dependency injection, typed navigation, localization, design tokens, and separate dev/staging/production configuration. Establish Android app identity, minimum SDK/device support, signing, crash reporting, analytics limits, and CI before feature work. Reuse the neighboring `Wonder-Wheels-Kids` Flutter patterns only after reviewing their suitability; do not copy its debug signing setup.
2. **Experience and account model:** Build onboarding, age-appropriate role selection, parent consent/verification, parent account, and locally isolated child profiles. Provide clear parent/child mode switching and a parent gate around settings, external links, purchases, account/data actions, and contact/support. Create a warm, distinctive illustrated visual system with high-contrast readable typography, accessible touch targets, restrained animations, and sound/haptic controls. Every playful interaction may have a short, licensed sound cue; include global mute/volume, reduced-motion, captions for spoken content, and no sound requirement for essential actions.
3. **Home and navigation:** Implement Home, Parenting, Kids Learning, and Settings as the primary navigation, plus a Contact/Help page reachable from parent mode. Home offers role-aware resume/recommendations, progress highlights, and short daily activities without exposing sensitive parent assessment results to child mode.
4. **Parenting section:** Deliver topic modules for child emotions, friendships, stress, study interests, and listening skills. Each module has reviewed, non-diagnostic educational guidance, age-appropriate scenarios, short quizzes, explanations, and a progress score with transparent meaning and next-step suggestions. Store results as private parent data; present trends as learning prompts, never a clinical diagnosis or ranking of the child.
5. **Kids learning section:** Implement Dictionary; Thirukkural with licensed/verified English and Tamil content and localization-ready language selection; language-letter tracing; drawing/sketch canvas with samples; motivational stories/activities; coding fundamentals; puzzles; science; and India/states history. Each module has age-banded activities, accessible interaction, completion/progress state, and knowledge checks/quizzes. Cache approved core lessons and progress locally for offline use, then sync safely when connected.
6. **AI assistant and safety:** Add a parent/child-scoped assistant for real-time clarification and guided practice. Start with push-to-talk voice and text fallback; do not implement always-on listening. Route provider credentials and policy enforcement through a backend, use short-lived session credentials where needed, apply age-aware moderation/input-output filtering, minimize or avoid retaining transcripts/audio, and offer parent controls, limits, and reporting. The assistant must not diagnose, solicit personal details, enable unsupervised external actions, or replace reviewed lesson content. Define escalation language for disclosures of harm and route support contact to an adult.
7. **Backend and operations:** Use Firebase as the recommended first implementation: Auth for parent identity, Firestore for parent-owned profiles/progress, Cloud Functions for privileged writes and AI orchestration, Storage for approved media, App Check, and FCM only for parent-approved notifications. Enforce least privilege and parent-child ownership in security rules; use server-side validation, encryption, environment separation, backups, auditability, data export/deletion, and retention limits. Maintain versioned localized content with editorial review/approval and licensing metadata; keep content distinct from app code.
8. **Quality, release, and launch:** Add unit tests for scoring, content/progress, and access rules; widget tests for mode boundaries, quizzes, audio controls, and navigation; integration tests for onboarding, offline sync, and account deletion; backend/security-rule tests; and Android device testing across small/large screens and accessibility settings. Configure CI for format/analyze/tests/build, release signing via protected secrets, Play internal testing, privacy/data-safety declarations, store assets, rollout/monitoring, crash triage, support ownership, and a rollback plan.

**Relevant files**
- Target project root: `c:\Users\gdkw48\Documents\Sources\MSI_Sample-Projects\Kids vs Parents` — now contains the Flutter Android scaffold and the first interactive app slice; the remaining files below are planned.
- `pubspec.yaml` — Flutter dependencies, localization generation, fonts, and assets.
- `lib/app/` — app bootstrap, theme/design tokens, routing, and dependency configuration.
- `lib/features/{home,parenting,learning,assistant,settings,contact}/` — feature-first screens, state, domain logic, and repositories.
- `lib/core/` — networking, persistence/offline sync, localization, accessibility, audio/haptics, and shared UI.
- `functions/` — backend AI orchestration, moderation, privileged writes, and account/data operations.
- `firestore.rules`, `storage.rules` — parent ownership and least-privilege enforcement, verified by emulator tests.
- `android/` — app identity, permissions, release signing configuration, and Play build settings.
- `test/`, `integration_test/`, `functions/test/` — unit, widget, workflow, and backend security coverage.
- Reference only: sibling `Wonder-Wheels-Kids/AGENTS.md`, `lib/features/`, `firestore.rules`, `functions/src/`, and `android/app/build.gradle.kts`; review and adapt patterns, especially replacing debug release signing.

**Verification**
1. `flutter analyze` and `flutter test` pass; add targeted tests for quiz scoring, role-separated data access, audio mute/reduced-motion, and offline progress sync.
2. Run Firebase Emulator Suite tests proving a parent can access only their own child profiles, child mode cannot reach parent-only routes/results, and privileged writes/AI calls are server-mediated.
3. Run Android integration tests on representative small and large devices, with TalkBack, reduced motion, muted audio, low connectivity, and app resume; verify no content or controls overlap.
4. Build a signed Android App Bundle in CI using protected release secrets; verify staging/prod config separation, permission declarations, privacy disclosures, deletion/export flows, and Play Families policy readiness before rollout.
5. Conduct parent/child usability and safety review of the assistant, quizzes, sound design, English/Tamil copy, content sources/licensing, and escalation flows before public release.

**Decisions**
- Platform: Flutter for an Android-first experience; defer iOS unless separately approved.
- Audience: ages 5-12 in India. Launch content in English and Tamil; architect for later Hindi/other languages. Verify Thirukkural translation and media rights before publishing.
- AI voice: push-to-talk, parent-managed and moderated, with text fallback; no always-on listening. A launch-grade live voice provider and cost/latency targets must be selected during implementation.
- Data and safety: parent consent/controls, minimal child identifiers, no targeted ads, no diagnosis claims, transparent score interpretation, data deletion/retention, and current legal/store policy review (including applicable Indian child-data requirements and Google Play Families policy).
- Backend: Firebase is a recommendation, not a locked decision; keep AI and content boundaries provider-agnostic where practical.
- Dependencies and setup must use `curation.motorolasolutions.com`; setup guide: https://confluence.mot-solutions.com/spaces/ARTIFACT/pages/1225147372/Curation.
- Scope excludes always-listening Alexa-style wake word, public social features, advertisements, clinical assessment, and an unmoderated generative tutor.

**Further Considerations**
1. Confirm whether both English and Tamil are launch languages, as assumed; recommendation: yes, with a content review workflow before enabling more locales.
2. Set an AI usage budget and operational owner before selecting voice/model providers; recommendation: per-profile limits, no transcript retention by default, and parent-visible controls.
3. Confirm whether offline downloads may include audio and drawing samples; recommendation: cache only reviewed text/core activities initially, with user-controlled media downloads.

**Implementation Status**
- Implemented: Home dashboard; parent/kids navigation modes; five parenting topics with scored quizzes; nine learning topics with scored quizzes; Tamil dictionary samples and Thirukkural; finger-drawn letter tracing and sketch canvas; local assistant preview; sound/haptic settings; and Contact/Help form preview.
- Verified: `flutter analyze --no-pub`, `flutter test --no-pub`, and `flutter build apk --debug --no-pub --target-platform android-arm64` pass. The APK is at `build/app/outputs/flutter-apk/app-debug.apk`.
- Not production-ready: the assistant is fixed local examples, voice is not connected, contact does not deliver, scores/settings are not persisted, parent mode is not authenticated, and no Firebase or parent-consent flow exists.
- Build note: the default multi-ABI debug build currently fails while configuring the `armeabi-v7a` CMake task; the ARM64-targeted APK build succeeds.
