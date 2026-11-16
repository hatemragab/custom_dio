## Unreleased — Flutter 3.50 migration

- Require Flutter 3.50 and Dart 3.14 or newer compatible versions.
- Migrate maintained Material/Cupertino imports to `material_ui`/`cupertino_ui` where used and apply the official Dart fixes.
- UI-facing theme and widget types now belong to the new design packages. Consumers must migrate together; legacy SDK `ThemeData`/`TextTheme` are distinct types. Treat this as a breaking release before publishing; no release is performed by this migration.
- Development examples may use `pubspec_overrides.yaml` for migrated sibling packages. Release compatible dependency versions and update hosted constraints before independent distribution.

## 0.0.1

* init realise

## 1.0.0
* stable realise

