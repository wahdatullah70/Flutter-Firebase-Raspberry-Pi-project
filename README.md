# Solar Pesticide Sprayer — Demo

This repository contains a minimal Flutter demo that shows a dashboard UI for a solar-powered pesticide sprayer and a tiny Raspberry Pi demo API.

Repository layout (important files)
- `lib/main.dart` — app UI and Pi integration (set Pi URL with cloud icon)
- `lib/widgets/data_widget.dart` — widget that polls the Pi `/data` endpoint
- `lib/services/data_service.dart` — HTTP client used by `DataWidget`
- `raspberry/` — small Flask API that demonstrates the Pi endpoint (`/data`)

Quick start

1. Ensure you have Flutter available (recommended: install Flutter normally and have `flutter` on PATH).

If you keep a local Flutter SDK for convenience, you can also run Flutter via its path.

2. Get Dart/Flutter dependencies:

```bash
flutter pub get
```

3. Build an Android debug APK:

```bash
flutter build apk --debug
```

4. Install on Android device (example):

```bash
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

If your device blocks ADB installs (MIUI), you can push the APK and install manually:

```bash
adb push build/app/outputs/flutter-apk/app-debug.apk /sdcard/Download/
# then open the file on the phone and install using the file manager
```

Raspberry Pi demo API

1. Change into the `raspberry` folder and create a virtualenv:

```bash
cd raspberry
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

2. Run the demo API (development server):

```bash
python3 solar_api.py
```

3. In the mobile app: tap the cloud icon (top-right), set the base URL to `http://<pi-ip>:5000` and the app will poll `/data`.

Notes
- Replace `raspberry/solar_api.py`'s `read_sensors()` function with real sensor code on the Pi.
- Use `flutter analyze` to check for analyzer hints and `flutter test` for unit/widget tests.

Global access to the Pi API (Cloudflare Tunnel)
- See [docs/cloudflare_tunnel_pi.md](docs/cloudflare_tunnel_pi.md)

Firebase backend setup (Auth / Firestore / Storage)

This app includes demo tabs for Firebase Auth (email/password), Firestore CRUD, and Firebase Storage.

1) In Firebase Console create a project.
2) Add an Android app with the same `applicationId` as [android/app/build.gradle.kts](android/app/build.gradle.kts) (currently `com.example.iee_project`).
3) Download `google-services.json` and place it at `android/app/google-services.json`.
4) Enable products you need:
	- Authentication → Sign-in method → enable Email/Password
	- Firestore Database → create database
	- Storage → get started

Platform notes
- Android: works using `google-services.json`.
- iOS/Web: you must also add the iOS/Web apps in Firebase Console and generate FlutterFire config (recommended), otherwise `Firebase.initializeApp()` will fail on those platforms.

Recommended (multi-platform): FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Then update initialization to use the generated `lib/firebase_options.dart`.

See also: [docs/firebase_android_setup.md](docs/firebase_android_setup.md)

Beginner guides
- Windows install/build: [docs/windows_install_and_build.md](docs/windows_install_and_build.md)
- Change Firebase project: [docs/change_firebase_project.md](docs/change_firebase_project.md)
# Solar Pesticide Sprayer — Demo

This is a minimal Flutter demo that shows a dashboard UI for a solar-powered pesticide sprayer.

Quick start

1. Ensure you have Flutter installed. You can use the included `flutter` binary in this repo:

```bash
flutter --version
```

2. Get dependencies:

```bash
flutter pub get
```

3. Run on a Linux desktop (if enabled):

```bash
flutter run -d linux
```

Or pick another connected device/emulator from `flutter devices`.

Notes
- The UI uses sample, hard-coded values — hook it up to your sensors/backend for a full app.
- If you prefer to use a globally-installed `flutter`, replace the path above with `flutter`.
