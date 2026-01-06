# Integration: Raspberry Pi → Mobile App

This document explains how to run the Raspberry Pi demo API and connect the
Flutter app to it for end-to-end testing.

1) Start the Pi demo API

```bash
cd raspberry
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python3 solar_api.py
```

The server will listen on port `5000` by default. Test from your workstation:

```bash
curl http://127.0.0.1:5000/data
```

On the Raspberry Pi, make sure the Pi has a reachable IP on your Wi-Fi/LAN
and that port `5000` is open (no firewall blocking local traffic).

2) Prepare and install the APK

From the project root:

```bash
flutter build apk --debug
adb push build/app/outputs/flutter-apk/app-debug.apk /sdcard/Download/
# then install via file manager OR
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

If `adb install` fails with `INSTALL_FAILED_USER_RESTRICTED` (commonly on
MIUI), either:

- Open the APK on the phone from Downloads and allow install from unknown
  sources for the file manager, or
- Enable Developer options → `USB debugging` and `Install via USB` (MIUI
  security settings may require a signed-in Mi account and special
  permission).

3) Connect the app to the Pi

- Open the installed app on the phone.
- Tap the cloud icon (top-right) and enter `http://<PI_IP>:5000` using the Pi
  IP address reachable from the phone.
- The Data panel will poll `/data` every 3s and show telemetry, or an error
  message if the app can't reach the Pi.

4) Troubleshooting

- If you see `No data (network or server error)` in the Data card, verify:
  - The Pi server is running and `curl http://<PI_IP>:5000/data` returns JSON.
  - The phone and Pi are on the same network (Wi‑Fi). Mobile data networks
    typically cannot reach local LAN addresses.
  - Any phone VPN/firewall or MIUI restricted networking setting is disabled.

- For persistent Pi deployment use `gunicorn` or systemd:

  ```bash
  # example: run with gunicorn on port 5000
  pip install gunicorn
  gunicorn -b 0.0.0.0:5000 solar_api:app
  ```
