# Request & Data Flows

This page explains how the major requests move through the system.

## 1. Login flow

```text
User
 │ email + password
 ▼
Flutter LoginScreen
 │
 ▼
AuthService
 │ signInWithEmailAndPassword()
 ▼
Firebase Authentication
 │
 ├── failure ──> FirebaseAuthException ──> UI message
 │
 └── success ──> Firebase User/session
                    │
                    ▼
              authStateChanges()
                    │
                    ▼
                 AuthGate
                    │
                    ▼
              BackendHomeScreen
```

The app does not maintain its own password database.

## 2. Sign-up flow

```text
User
 │ email + password + confirmation
 ▼
Client validation
 │
 ▼
createUserWithEmailAndPassword()
 │
 ▼
Firebase Authentication
 │
 ▼
Authenticated Firebase user
```

## 3. Firestore flow

```text
Authenticated Flutter app
       │
       │ Firebase SDK request
       ▼
Cloud Firestore
       │
       ▼
Firestore Security Rules
       │
       ├── request.auth == null ──> deny
       └── authenticated ─────────> allow according to rule
```

The client does not manually construct Firebase bearer tokens for Firestore calls; the SDK manages the authenticated session.

## 4. Storage flow

```text
User selects file
      │
      ▼
Flutter StorageService
      │
      ▼
Firebase Storage SDK
      │
      ▼
Storage Security Rules
      │
      ▼
uploads/<uid>/...
```

The recommended rules scope file access to the authenticated UID.

## 5. Raspberry Pi telemetry flow

```text
Flutter dashboard
      │
      │ GET <baseUrl>/data
      │ X-API-Key: <token>  (optional)
      ▼
Flask API on Raspberry Pi
      │
      ├── SOLAR_API_TOKEN configured?
      │       │
      │       ├── no  ──> continue
      │       └── yes ──> compare X-API-Key
      │                    ├── mismatch ──> 401
      │                    └── match ─────> continue
      ▼
read_sensors()
      │
      ▼
JSON telemetry
      │
      ▼
Flutter DataWidget
```

## 6. Optional Cloudflare Tunnel flow

```text
Flutter app
   │ HTTPS
   ▼
Public tunnel hostname
   │
   ▼
Cloudflare Tunnel
   │ outbound tunnel connection
   ▼
Raspberry Pi :5000
```

This avoids directly exposing the Pi with a router port-forward in the documented setup.

## Error-handling behavior

- Firebase auth errors are surfaced to the UI.
- Firestore permission failures are shown as a user-readable permission message.
- Pi API non-200 responses are treated as unavailable data in the demo client.
- Network/JSON failures are caught so the UI can continue running.

## Engineering takeaway

The project deliberately uses two authentication domains:

1. **Firebase identity** for user-facing application services.
2. **Shared API token** for the Raspberry Pi telemetry endpoint.

Keeping those mechanisms separate makes the trust boundaries easier to reason about and document.
