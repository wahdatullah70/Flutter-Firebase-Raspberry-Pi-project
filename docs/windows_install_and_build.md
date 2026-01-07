# Windows: Install / Run / Build the App (Beginner Guide)

This guide is written for a **non-technical person**. Follow it step-by-step.

What you can do on Windows:
- Run the app on an **Android phone** (recommended)
- Build an **APK file** and install it on a phone
- (Optional/advanced) Run as a **Windows desktop app**

---

## Option A (Recommended): Run the app on your Android phone using Windows

### Step 1 — Install Flutter on Windows
1. Download Flutter (Windows) from the official Flutter website.
2. Extract it to a simple folder, for example: `C:\src\flutter`.
3. Add Flutter to PATH:
   - Open **Start** → search **Environment Variables** → open **Edit the system environment variables**
   - Click **Environment Variables**
   - In **System variables**, select **Path** → **Edit** → **New**
   - Add: `C:\src\flutter\bin`
4. Open **PowerShell** and run:

```powershell
flutter --version
flutter doctor
```

If `flutter doctor` shows missing items, it will tell you what to install.

### Step 2 — Install Git (needed to download the project)
1. Install Git for Windows.
2. Open PowerShell and run:

```powershell
git --version
```

### Step 3 — Download (clone) this project
1. Open PowerShell.
2. Go to a folder where you keep projects, for example:

```powershell
cd C:\Users\<YourName>\Documents
```

3. Clone the repo:

```powershell
git clone git@github.com:wahdatullah70/iee_project.git
cd iee_project
```

If the `git clone` command asks for SSH keys and you don’t have them, tell me and I’ll guide you with the easiest option.

### Step 4 — Connect your Android phone
1. On your phone, enable **Developer options**.
2. Enable **USB debugging**.
3. Connect the phone by USB.
4. On Windows, run:

```powershell
flutter devices
```

You should see your phone in the list.

### Step 5 — Run the app (developer mode)
From the project folder:

```powershell
flutter pub get
flutter run
```

---

## Option B: Build an APK and install it on a phone (no coding)

### Step 1 — Build the release APK
From the project folder:

```powershell
flutter pub get
flutter build apk --release
```

### Step 2 — Find the APK file
After the build finishes, the APK is usually here:
- `build\app\outputs\flutter-apk\app-release.apk`

### Step 3 — Install the APK on your phone
Two simple ways:
1) **Copy the APK** to your phone (USB cable) → open it from File Manager → install
2) Use `adb` (Android platform tools). This is optional.

---

## Option C (Optional / Advanced): Run as a Windows desktop app

Important:
- Right now this project’s Firebase setup is **Android-focused** (`android/app/google-services.json`).
- A Windows desktop build with Firebase usually needs extra setup (FlutterFire config) and code changes.

If you want the app to run on Windows desktop **with Firebase working**, tell me and I will guide you and/or update the project to support Windows properly.
