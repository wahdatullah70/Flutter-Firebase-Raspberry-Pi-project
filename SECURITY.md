# Security Policy

This project combines a mobile client, Firebase services, and a Raspberry Pi API. Treat all credentials and device access details as sensitive.

## Never commit

- Firebase service-account JSON files
- API tokens or passwords
- private SSH keys
- production Raspberry Pi credentials
- private tunnel credentials
- production database exports
- secrets copied from CI/CD settings

The Android `google-services.json` file is client configuration, not an admin credential, but Firebase rules still need to be configured securely.

## API security

The Raspberry Pi API supports an `X-API-Key` pattern. In real deployments:

- load the token from an environment variable;
- use HTTPS or a trusted tunnel;
- rotate exposed tokens;
- restrict network reachability;
- avoid embedding privileged secrets in the mobile application.

## Firebase security

Use authenticated access, least-privilege Firestore/Storage rules, and separate development/production projects when appropriate.

## Reporting

Report security issues privately to the repository owner. Do not post active credentials, tokens, or exploitable production details in a public issue.
