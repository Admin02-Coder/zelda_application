# zelda_application

A Flutter application with Firebase authentication.

## Prerequisites

- Flutter SDK (3.x or later)
- Android Studio or VS Code with Flutter extension
- Firebase project

## Setup Instructions

### 1. Create a Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or use an existing one

### 2. Add Android App

1. In Firebase Console, add an Android app
2. Enter the package name: `com.zelda.zelda_application`
3. (Optional) Enter app nickname
4. Download the `google-services.json` file

### 3. Enable Authentication

In Firebase Console:

1. Go to **Authentication** → **Sign-in method**
2. Enable **Email/Password**
3. Enable **Google** sign-in

### 4. Configure the App

1. Place the downloaded `google-services.json` in:
   ```
   android/app/google-services.json
   ```

2. Get your Firebase configuration:

   If you need to customize the Firebase configuration, edit `lib/firebase_options.dart`:
   ```dart
   // Replace with your Firebase project settings
   // You can find these in Firebase Console → Project Settings
   ```

### 5. Run the App

```bash
flutter pub get
flutter run
```

## Security Notes

- The `google-services.json` and `lib/firebase_options.dart` files contain sensitive API keys and are not included in this repository for security reasons.
- Each developer must add their own Firebase configuration.
- Never commit sensitive files to version control.

## Troubleshooting

### "Requests from this Android client application are blocked"

This usually means the API key has restrictions that don't match your app:

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Find your project → **APIs & Services** → **Credentials**
3. Edit your API key and ensure the Android app package (`com.zelda.zelda_application`) is allowed under "Application restrictions"

### Authentication Errors

Make sure both Email/Password and Google sign-in are enabled in Firebase Console → Authentication → Sign-in method.
