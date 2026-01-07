# Change Firebase Account / Project (Beginner Guide)

This guide explains how to "change Firebase" for this app.

Important note (simple explanation):
- The app does **not** connect to a “Firebase account”.
- It connects to a **Firebase Project**.
- If you switch to a new Firebase Project, your **old users/data will NOT automatically move**.

---

## What you will change in this Flutter project
For Android, the main file that connects your app to Firebase is:
- `android/app/google-services.json`

To switch Firebase, you normally replace that file with a new one from the new Firebase project.

---

## Step-by-step: Switch to a new Firebase Project

### Step 1 — Create a new Firebase Project
1. Login to Firebase Console using the Google account you want.
2. Click **Add project**.
3. Finish project creation.

### Step 2 — Add the Android app inside Firebase
1. Firebase Console → **Project settings** → **Your apps**
2. Click **Add app** → choose **Android**
3. For **Android package name**, use the same package name as this project:
   - Current package name is in `android/app/build.gradle.kts` → `applicationId`
   - Current value: `com.example.iee_project`
4. Download **google-services.json**

### Step 3 — Put the new `google-services.json` into the project
1. Copy the downloaded file.
2. Paste it here (replace the existing one):
   - `android/app/google-services.json`

### Step 4 — Enable the Firebase features used by the app
In the Firebase Console (same project):

1) Authentication
- Go to **Authentication** → **Sign-in method**
- Enable **Email/Password**

2) Firestore Database
- Go to **Firestore Database** → **Create database**

3) Storage
- Go to **Storage** → **Get started**

### Step 5 — Run the app again
From the project folder:

```bash
flutter clean
flutter pub get
flutter run
```

Now the app should connect to the **new** Firebase project.

---

## Common mistakes (and how to avoid them)

1) Wrong package name
- If you change `applicationId` in Android, you MUST also add a new Android app in Firebase with the new package name.

2) App opens but login/Firestore fails
- Usually because Authentication / Firestore / Storage is not enabled in the new Firebase project.

3) You can’t login with old users
- Normal. Old users were stored in the old Firebase project.

---

## Optional (Recommended): Multi-platform Firebase setup

Right now the code uses:
- `await Firebase.initializeApp();`

This usually works for Android (using `google-services.json`).
If you later want **Web / iOS / Windows** to work reliably with Firebase, the recommended way is FlutterFire CLI, which generates `lib/firebase_options.dart` and the app initializes like this:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

If you want, I can add this setup for you and write an even simpler guide for it.
