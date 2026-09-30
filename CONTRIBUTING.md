# Contributing

## Development workflow

1. Create a focused branch.
2. Install dependencies:

```bash
flutter pub get
```

3. Run static analysis:

```bash
flutter analyze
```

4. Run tests:

```bash
flutter test
```

5. If you changed the Raspberry Pi API, test the Flask endpoint separately.
6. Update `docs/` when authentication, Firebase structure, request flow, or deployment behavior changes.
7. Never commit credentials or private device/tunnel details.

## Pull requests

Describe:

- what changed;
- why it changed;
- how you tested it;
- whether Firebase or Pi configuration is required;
- any security implications.

Keep demonstration values clearly separated from real production credentials and sensor data.
