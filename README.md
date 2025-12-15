# Solar Pesticide Sprayer — Demo

This repository contains a minimal Flutter demo that shows a dashboard UI for a solar-powered pesticide sprayer and a tiny Raspberry Pi demo API.

Repository layout (important files)
- `lib/main.dart` — app UI and Pi integration (set Pi URL with cloud icon)
- `lib/widgets/data_widget.dart` — widget that polls the Pi `/data` endpoint
- `lib/services/data_service.dart` — HTTP client used by `DataWidget`
- `raspberry/` — small Flask API that demonstrates the Pi endpoint (`/data`)

Quick start

1. Ensure you have Flutter available. The repo includes a local Flutter SDK at `./flutter_linux_3.38.5-stable/flutter`.

```bash
# From the workspace root
./flutter_linux_3.38.5-stable/flutter/bin/flutter --version
```

2. Get Dart/Flutter dependencies:

```bash
./flutter_linux_3.38.5-stable/flutter/bin/flutter pub get
```

3. Build an Android debug APK:

```bash
./flutter_linux_3.38.5-stable/flutter/bin/flutter build apk --debug
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
# Solar Pesticide Sprayer — Demo

This is a minimal Flutter demo that shows a dashboard UI for a solar-powered pesticide sprayer.

Quick start

1. Ensure you have Flutter installed. You can use the included `flutter` binary in this repo:

```bash
# From the workspace root
./flutter_linux_3.38.5-stable/flutter/bin/flutter --version
```

2. Get dependencies:

```bash
./flutter_linux_3.38.5-stable/flutter/bin/flutter pub get
```

3. Run on a Linux desktop (if enabled):

```bash
./flutter_linux_3.38.5-stable/flutter/bin/flutter run -d linux
```

Or pick another connected device/emulator from `flutter devices`.

Notes
- The UI uses sample, hard-coded values — hook it up to your sensors/backend for a full app.
- If you prefer to use a globally-installed `flutter`, replace the path above with `flutter`.
