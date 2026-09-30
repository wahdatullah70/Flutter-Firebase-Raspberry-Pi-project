# Security Model

The project uses different controls for Firebase services and the Raspberry Pi API.

## Authentication domains

### Firebase user identity

Used for:

- application sign-in;
- Firestore access;
- Firebase Storage access.

Firebase Authentication manages the user session. The application should not store or log user passwords.

### Raspberry Pi API key

Used for:

- protecting the optional `/data` telemetry endpoint.

The server reads the expected secret from:

```text
SOLAR_API_TOKEN
```

The client sends:

```http
X-API-Key: <token>
```

## Authorization

Authentication alone is not enough. Firebase Security Rules determine whether authenticated users are authorized to access data.

Recommended examples are documented in `firebase_android_setup.md`.

## Secret handling

Do not commit:

- Firebase Admin service-account keys;
- Raspberry Pi API tokens;
- private SSH keys;
- Cloudflare tunnel credentials;
- passwords;
- privileged backend credentials.

Use environment variables, platform secret stores, or deployment-specific secret management.

## Public Firebase configuration

Client Firebase configuration identifies the project/app but is not a substitute for authorization. Data protection must come from Firebase Auth + Security Rules.

## Transport security

For remote Pi access, prefer HTTPS. The documented Cloudflare Tunnel path provides a way to avoid exposing the Flask port directly to the public Internet.

## Current limitations

The Raspberry Pi mechanism is a simple shared secret. For a larger deployment, stronger options could include:

- per-device credentials;
- short-lived tokens;
- mutual TLS;
- centralized identity;
- token rotation and revocation.

## Review checklist

- [ ] Firebase rules do not allow unnecessary public access
- [ ] no Admin SDK credentials are in the repository
- [ ] API token is injected at runtime
- [ ] remote traffic uses HTTPS
- [ ] sensitive logs do not expose credentials
- [ ] production and development credentials are separated
