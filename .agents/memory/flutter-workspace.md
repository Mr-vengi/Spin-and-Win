---
name: Flutter workspace support
description: How this Replit pnpm workspace hosts Flutter projects and previews.
---

Flutter is not currently an artifact type in the workspace's artifact bootstrap templates. Keep Flutter/Dart projects as real Flutter source directories and serve web previews through a custom workflow; do not substitute Expo when the user explicitly asks for Flutter.

**Why:** Converting a Flutter request to Expo changes the requested platform and implementation stack. The Flutter SDK can be installed as a Nix system dependency, but Android tooling and a device may still be unavailable in the workspace.

**How to apply:** For Flutter apps, scaffold with `flutter create`, keep Dart sources and `pubspec.yaml` in the app folder, and configure a non-artifact web-server workflow on an unused supported port. Verify with `flutter analyze` and `flutter build web`; native Android/iOS execution depends on the available SDK/device.
