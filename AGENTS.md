# AGENTS.md

Guidance for AI agents and contributors working in this repository.

## Commands

| Task | Command |
| --- | --- |
| Install deps | `flutter pub get` |
| Regenerate codegen | `dart run build_runner build --delete-conflicting-outputs` |
| Static analysis | `flutter analyze` |
| Tests | `flutter test` |
| Debug APK | `flutter build apk --debug` |
| Release APK | `flutter build apk --release --split-per-abi` |
| Deploy backend | `firebase deploy --only firestore:rules,firestore:indexes,storage` |

## Repo conventions

- Data models live in `lib/src/models/models.dart` (Freezed) and are generated
  to `models.freezed.dart` / `models.g.dart` by `build_runner`. Never edit the
  generated files by hand.
- Firestore security rules compare `createdAt` / `updatedAt` / `sentAt` to
  `request.time`. Because of that, repository write paths must send
  `FieldValue.serverTimestamp()` for those fields — client-clock timestamps
  will be rejected due to clock skew (`lib/src/data/firestore_repository.dart`).
- Any new Firestore query with multiple fields (or array-contains + orderBy)
  must be mirrored in `firestore.indexes.json`, or reads will fail at runtime
  with a missing-index error.
- State is Riverpod only; screens never talk to Firebase directly, they go
  through the repo providers in `lib/src/providers.dart`.
- Keep `flutter analyze` clean and `flutter test` green before finishing.

## Known limitations

- No Cloud Function yet: FCM tokens are collected on the user profile, but
  delivery requires a backend sender (out of scope).
- Release builds sign with the debug key until `android/key.properties` is
  configured (see `android/key.properties.example`); keep that file untracked.