# custom_dio agent guide

Read the workspace and global `AGENTS.md` instructions, this repository's README, the affected manifest, and relevant source before editing. Preserve existing changes and keep work within the requested task.

## Package layout

- `.`: Flutter package/app.
- `example`: Flutter package/app with an existing web runner.

Paths are relative to this repository; `.` is its root. Read nested instructions before changing a component. Preserve the existing state management, service boundaries, public APIs, assets, and platform behavior.

## Flutter 3.50 and Dart 3.14

Use the installed compatible SDK; do not globally switch toolchains. Keep SDK constraints and direct dependencies consistent with source imports. Material and Cupertino widgets use `material_ui` and `cupertino_ui`; use `flutter/widgets.dart` or other style-neutral SDK libraries when design widgets are unnecessary.

Resolve dependencies in each affected package with `flutter pub get --no-example` (or `dart pub get --no-example` for pure Dart). When migrating design widgets, run `dart fix --apply --code=migrate_design_widgets`, review its changes, and add any missing direct dependencies. For every code-change verification pass, run these sequentially from the affected package:

```sh
dart fix --apply
dart format .
flutter analyze
```

Fix and format must finish before analysis or tests. If code changes after analysis, repeat that sequence. Do not suppress diagnostics or exclude maintained source to obtain a pass. Fix the cause and preserve tool-owned generated files.

For the existing web app, run `flutter build web` from `example`. Use Playwright MCP for browser checks.

## Coding and review

Use one handwritten class/widget per file; a StatefulWidget and its paired State may share a file. Apply SOLID without speculative abstractions, keep UI separate from transport and persistence, and reuse existing helpers and dependencies. Prefer explicit types, visible error handling, and correct asynchronous ownership and disposal.

Use focused tests only when requested or needed to prove a behavior change. Do not run native builds, provision devices, publish, push, or deploy without task authorization. Report exact commands and distinguish analyzer/build evidence from runtime or provider integration evidence. Never expose credentials or commit environment files, generated caches, or build outputs.
