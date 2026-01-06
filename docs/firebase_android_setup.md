# Firebase (Android) Setup Guide — Solar Pesticide Sprayer

This guide explains how to connect this Flutter app to Firebase on **Android** and how to push the project to GitHub safely.

## 1) Create Firebase project
1. Go to Firebase Console → **Add project**.
2. Finish project creation.

## 2) Add Android app in Firebase
1. Firebase Console → Project settings → **Your apps** → **Add app** → Android.
2. Enter the Android package name (must match the app):
   - Check it in [android/app/build.gradle.kts](../android/app/build.gradle.kts) → `defaultConfig.applicationId`
   - Current value: `com.example.iee_project`
3. Download `google-services.json`.
4. Put it here in the Flutter project:
   - `android/app/google-services.json`

## 3) Enable Firebase products used by this app
### Authentication
- Firebase Console → **Authentication** → **Sign-in method**
- Enable **Email/Password**

### Firestore
- Firebase Console → **Firestore Database** → Create database

### Storage
- Firebase Console → **Storage** → Get started

## 4) Recommended security rules (so the demo works, but still safe)

### Firestore Rules
This project uses a demo collection called `demo_items`.

Firebase Console → Firestore Database → **Rules**:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /demo_items/{doc} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### Storage Rules
Uploads are stored under `uploads/<uid>/...`.

Firebase Console → Storage → **Rules**:

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /uploads/{uid}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }
  }
}
```

## 5) Run the app
From the project root:

```bash
flutter pub get
flutter run -d <your-android-device>
```

If you don’t have `flutter` on PATH, install Flutter normally (recommended) or configure it in your environment.

## 6) What you should see in the app
- A **Login / Create account** screen.
- After login, you can access the app.
- Firestore tab: add/edit/delete items in `demo_items`.
- Storage tab: pick a file and upload it (requires login).

## 7) GitHub: what to commit vs not commit
### Safe to commit
- All Flutter source under `lib/`
- Android project files under `android/`
- `android/app/google-services.json` (common practice; it’s not a secret key)

### Do NOT commit
- `build/`
- Local SDK folders, virtualenvs
- Any Admin SDK service account JSON keys

This repo already has a `.gitignore` updated for that.

## 8) Push to GitHub
```bash
git add -A
git commit -m "Add Firebase auth gate + docs"

git remote add origin https://github.com/<you>/<repo>.git
git push -u origin main
```
