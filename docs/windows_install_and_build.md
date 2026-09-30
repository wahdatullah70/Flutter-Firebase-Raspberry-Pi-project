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

If `flutter doctor` shows missing items, install or configure the components it reports.

### Step 2 — Install Git
1. Install Git for Windows.
2. Open PowerShell and run:

```powershell
git --version
```

### Step 3 — Download this project
1. Open PowerShell.
2. Go to a folder where you keep projects, for example:

```powershell
cd C:\Users\<YourName>\Documents
```

3. Clone the current repository:

```powershell
git clone https://github.com/wahdatullah70/Flutter-Firebase-Raspberry-Pi-project.git
cd Flutter-Firebase-Raspberry-Pi-project
```

### Step 4 — Connect your Android phone
1. On your phone, enable **Developer options**.
2. Enable **USB debugging**.
3. Connect the phone by USB.
4. On Windows, run:

```powershell
flutter devices
```

You should see your phone in the list.

### Step 5 — Run the app
From the project folder:

```powershell
flutter pub get
flutter run
```

---

## Option B: Build an APK and install it on a phone

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
1. Copy the APK to your phone using USB, then open it from the File Manager and install it.
2. Use `adb install build\app\outputs\flutter-apk\app-release.apk` if Android platform tools are installed.

---

## Option C (Optional / Advanced): Run as a Windows desktop app

Important:
- This project’s Firebase setup is primarily **Android-focused** (`android/app/google-services.json`).
- A Windows desktop build using Firebase may require additional FlutterFire configuration and platform-specific setup.

For a Firebase-enabled Windows build, configure the Windows platform with the FlutterFire CLI and verify the generated Firebase options before deployment.
