# Deployment Workflow

This project has two deployable parts:

1. the Flutter application;
2. the Raspberry Pi Flask telemetry API.

Firebase is a managed backend configured separately in the Firebase Console.

## Deployment overview

```text
Developer machine
   │
   ├── flutter build apk
   │        │
   │        ▼
   │    Android device
   │
   ├── Firebase project configuration
   │        │
   │        ▼
   │    Auth / Firestore / Storage
   │
   └── Pi API files
            │
            ▼
       Raspberry Pi
            │
            ├── Flask / Gunicorn
            └── optional Cloudflare Tunnel
```

## Flutter / Android

Install dependencies:

```bash
flutter pub get
```

Run static analysis:

```bash
flutter analyze
```

Build a debug APK:

```bash
flutter build apk --debug
```

Build release APK when signing/configuration is ready:

```bash
flutter build apk --release
```

## Firebase configuration

Follow:

- `firebase_android_setup.md`
- `change_firebase_project.md`

Before running the app, ensure:

- the Android application ID matches the Firebase app registration;
- `google-services.json` is placed correctly;
- Email/Password auth is enabled;
- Firestore exists;
- Storage exists;
- security rules are configured.

## Raspberry Pi API

```bash
cd raspberry
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

For local validation:

```bash
python3 solar_api.py
```

For a more production-like process manager:

```bash
gunicorn -b 0.0.0.0:5000 solar_api:app
```

## API authentication

Set the API token in the Pi environment rather than source code:

```bash
export SOLAR_API_TOKEN='replace-with-a-strong-secret'
```

Test:

```bash
curl http://127.0.0.1:5000/data
curl -H "X-API-Key: $SOLAR_API_TOKEN" http://127.0.0.1:5000/data
```

When a token is configured, the first request should be unauthorized and the second should return telemetry.

## Remote access

For the optional tunnel design, follow `cloudflare_tunnel_pi.md`.

## Deployment checklist

- [ ] Flutter dependencies resolve
- [ ] `flutter analyze` completes
- [ ] Android build completes
- [ ] Firebase project points to the intended environment
- [ ] Auth sign-in method enabled
- [ ] Firestore/Storage rules reviewed
- [ ] Pi virtual environment created
- [ ] `/data` works locally
- [ ] `SOLAR_API_TOKEN` tested
- [ ] HTTPS/tunnel configured if remote access is required
- [ ] no secrets committed to Git

## Production-hardening ideas

If the demo evolves into a deployed product, consider:

- OS service management for the Pi API;
- structured logging;
- health checks and restart policy;
- TLS-only remote access;
- token rotation;
- per-device identity instead of one shared API key;
- monitoring and alerting;
- Firebase App Check where appropriate;
- separate development and production Firebase projects.
