README for Windows — Flutter IoT App (hand-off)
===============================================

Overview
--------
This repository contains a Flutter Android app that polls a Raspberry‑Pi style REST endpoint (`/data`) and displays telemetry (power_w, battery_v, status, timestamp).
This small README explains how to run the app and the included demo server on Windows, plus quick troubleshooting.

Files included in this hand-off
- Project source (Flutter app): all files in this repo
- Demo server: `raspberry/solar_api.py` (Flask)
- Debug APK (built): `build/app/outputs/flutter-apk/app-debug.apk` (included in the handoff zip)

Prerequisites (Windows)
-----------------------
- Git
- Flutter SDK (stable). Install from https://docs.flutter.dev/get-started/install/windows and add `flutter\bin` to PATH.
- Android Studio (recommended) or Android SDK/command-line tools. Install Android SDK Platform, Platform Tools (adb) and an AVD if you want the emulator.
- Java JDK 11 or 17 (OpenJDK recommended)
- Python 3 (for the demo Flask server)
- Optional: ngrok if you need to expose the demo server to the internet

Quick Steps — run demo server + app (recommended)
-----------------------------------------------
1) Clone or copy this repo to Windows:

```powershell
git clone <repo-url>
cd iee_project
```

2) Start the demo Flask server (opens `/data`):

```powershell
cd raspberry
python -m venv .venv_flask
.\.venv_flask\Scripts\Activate.ps1   # use activate.bat if you prefer cmd.exe
pip install -r requirements.txt
python solar_api.py
```

The server listens on `http://127.0.0.1:5000` and on your PC LAN IP (e.g. `http://192.168.x.y:5000`). Verify with:

```powershell
curl http://127.0.0.1:5000/data
```

3) Run the Flutter app (emulator or device):

```powershell
cd ..\               # repo root
flutter pub get
flutter devices       # shows available devices/emulators
flutter run -d <device-id>
```

4) Point the app to the demo server (in the app UI use the cloud icon)
- If device and PC are on same Wi‑Fi: set Pi URL to `http://<PC_IP>:5000` (find PC IP with `ipconfig`).
- If device is connected via USB and you want to map device-localhost to host: run

```powershell
adb reverse tcp:5000 tcp:5000
```

  then set Pi URL to `http://127.0.0.1:5000` in the app.
- If using Android emulator, use `http://10.0.2.2:5000`.

Testing without the Pi
----------------------
- The `raspberry/solar_api.py` script returns realistic telemetry JSON at `/data`. Use it to test UI and error handling.

Useful commands
---------------
- Build debug APK:
  ```powershell
  flutter build apk --debug
  ```
- Install APK manually:
  ```powershell
  adb install -r build\app\outputs\flutter-apk\app-debug.apk
  ```

What the app does (short)
-------------------------
- `lib/main.dart` — app entry, Pi URL dialog, mapping toggle, and the main dashboard.
- `lib/services/data_service.dart` — HTTP client that GETs `<baseUrl>/data` and returns parsed JSON.
- `lib/widgets/data_widget.dart` — polls `/data` every 3s and displays `power_w`, `battery_v`, `status`, and timestamp. Shows loading and error states.

Troubleshooting
---------------
- `flutter doctor` reports missing SDKs or licenses — run `flutter doctor` and `flutter doctor --android-licenses`.
- If emulator can't start: enable VT-x/virtualization in BIOS and create an AVD with Google APIs.
- Device not visible: enable USB debugging on device and accept the authorization prompt; ensure `adb devices` lists the device.
- App can't reach server: check firewall, use `adb reverse` or emulator host mapping (`10.0.2.2`).
- Xiaomi/MIUI may block `adb install` — enable 'Install via USB' in Developer Options or install APK manually from Downloads on the phone.

Hand-off notes
--------------
- The Field Mapping state is currently in-memory (not persisted). If you want persistent mapping, save the state using `SharedPreferences` or a local database.
- Tests: no automated widget/integration tests are included yet — recommended next work.
- Build artifacts are excluded from source control in `.gitignore` (do not commit `build/` folder).

If anything fails, please copy the output of `flutter doctor -v`, the log lines shown by the Flask server, and any `adb` output and send them to me; I can debug further.

Enjoy — send me a screenshot if you want me to verify the UI state or help record a quick demo video.

-- End of README_for_friend.md
