# Troubleshooting Runbook

## Flutter app does not start

```bash
flutter doctor
flutter pub get
flutter analyze
flutter devices
```

Check SDK installation, connected device/emulator, and dependency resolution.

## Firebase initialization fails

Verify:

- `google-services.json` is in `android/app/`;
- package/application ID matches Firebase registration;
- the app is using the intended Firebase project;
- platform-specific Firebase configuration exists for the platform being run.

## Login fails

Check Firebase Console → Authentication → Sign-in method and confirm **Email/Password** is enabled.

Also inspect the user-visible `FirebaseAuthException` message.

## Firestore says permission denied

Review Firestore Security Rules. Authentication success does not automatically grant database access.

Confirm the app is signed in:

```dart
FirebaseAuth.instance.currentUser
```

Then compare the request with the configured rules.

## Storage upload fails

Check:

- authenticated UID;
- upload path;
- Storage rules;
- file permissions on the client;
- Firebase Storage configuration.

## Pi API unavailable

On the Raspberry Pi:

```bash
ss -ltnp | grep 5000
curl http://127.0.0.1:5000/data
```

From another machine on the LAN:

```bash
curl http://<pi-ip>:5000/data
```

Check firewall rules, IP address, routing, and whether the Flask/Gunicorn process is running.

## Pi API returns 401

If `SOLAR_API_TOKEN` is set, include the API key:

```bash
curl -H "X-API-Key: $SOLAR_API_TOKEN" http://127.0.0.1:5000/data
```

Ensure the client token exactly matches the server-side environment variable.

## Tunnel hostname does not work

Test the local Pi service first. If local `/data` fails, fix the API before debugging Cloudflare Tunnel.

Then verify tunnel process/status, hostname routing, and tunnel credentials.

## Android device cannot reach local machine / Pi

Common checks:

- phone and Pi are on reachable networks;
- correct LAN IP is used;
- Android network-security restrictions are understood for HTTP development traffic;
- firewall permits the port;
- emulator uses the correct host mapping when testing a service on the development PC.

## Useful incident template

```text
Component:
Device/platform:
Expected:
Observed:
Error message:
Network path:
Authentication state:
Commands/tests run:
Root cause:
Fix:
```

A structured troubleshooting record is useful because this project crosses multiple layers: Flutter UI, Firebase, networking, HTTP, Flask, and Raspberry Pi runtime behavior.
