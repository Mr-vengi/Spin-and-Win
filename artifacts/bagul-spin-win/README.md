# Bagul Spin & Win

A Flutter/Dart mobile app prototype for Bagul Spin & Win.

## Run

```bash
cd artifacts/bagul-spin-win
flutter pub get
flutter run -d web-server
```

This is the manual Flutter web run command requested in the brief. To run on a
connected Android device or emulator, use `flutter run -d android` from this
directory. An iOS build requires macOS and Xcode.

The Replit preview serves `build/web` on port 8099 as a static site. After
changing the app, run `flutter build web --release` to refresh what the preview
displays.

## Validate

```bash
cd artifacts/bagul-spin-win
dart format lib
flutter analyze
flutter build web --release
```

## Prototype behavior

Profiles, wallet balance, delivery address, referral demo counts, and claimed
gifts are stored on-device with SharedPreferences. Passwords are not saved.
The local login is a preview flow, not production authentication. Top-ups,
withdrawals, referral verification, and tracking status changes are simulated;
connect a trusted backend before using them with real money or shipping.
