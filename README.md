# Flutter Notes App

A simple and elegant notes application built with Flutter and Firebase, featuring authentication and full CRUD operations.

## Features

- ✅ **User Authentication**
  - Email/Password sign up and login
  - Secure session persistence
  - Automatic logout functionality

- ✅ **Notes Management**
  - Create, read, update, and delete notes
  - Real-time synchronization
  - User-specific data isolation (users can only see their own notes)

- ✅ **Offline Support**
  - Works without internet connection
  - Automatic data sync when connection is restored
  - Cached data for offline viewing

- ✅ **Clean UI**
  - Modern Material Design 3
  - Intuitive navigation
  - Responsive layouts
  - Empty and error states

## Tech Stack

- **Frontend:** Flutter 3.35.7
- **Backend:** Firebase
  - Firebase Authentication (Email/Password)
  - Cloud Firestore (Database)
- **State Management:** Provider pattern with StreamBuilder
- **Offline Persistence:** Firestore offline cache

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- Android Studio / VS Code
- Firebase account
- Android device or emulator (API level 21+)

## Setup Instructions

### 1. Clone the Repository

```bash
git clone <repository-url>
cd flutter_notes_app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Firebase Configuration

#### Create Firebase Project:
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Enable **Email/Password** authentication in Authentication section
4. Create a **Firestore Database** in test mode

#### Add Android App:
1. In Firebase Console, add an Android app
2. Package name: `com.example.flutter_notes_app`
3. Download `google-services.json`
4. Place it in `android/app/google-services.json`

#### Configure Firestore Security Rules:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /notes/{noteId} {
      allow read, write: if request.auth != null 
        && request.auth.uid == resource.data.userId;
      allow create: if request.auth != null 
        && request.auth.uid == request.resource.data.userId;
    }
  }
}
```

### 4. Run the App

```bash
# Run in debug mode
flutter run

# Or build APK
flutter build apk --release
```

The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

## Database Schema

### Firestore Collection: `notes`

```javascript
{
  "id": "auto-generated-document-id",
  "title": "string",
  "content": "string",
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "userId": "string (Firebase Auth UID)"
}
```

**Indexes:**
- Composite index on `userId` (Ascending) + `updatedAt` (Descending)
- Auto-created on first query

## Authentication Approach

- **Firebase Authentication** with email/password provider
- **Session Persistence:** Firebase automatically maintains user sessions across app restarts
- **Auth State Stream:** Real-time authentication state changes using `authStateChanges()`
- **Security:** Firestore security rules ensure users can only access their own notes

## Project Structure

```
lib/
├── main.dart                 # App entry point, Firebase initialization
├── models/
│   └── note_model.dart      # Note data model
├── services/
│   ├── auth_service.dart    # Authentication service
│   └── notes_service.dart   # Notes CRUD service
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   └── notes/
│       ├── notes_list_screen.dart
│       └── note_editor_screen.dart
├── widgets/
│   └── note_card.dart       # Note list item widget
└── utils/
    └── constants.dart       # App constants and colors
```

## Assumptions and Trade-offs

### Why Firebase over Supabase?
- Better Flutter integration with official packages
- Simpler authentication setup
- Built-in offline persistence
- Easier security rules implementation
- More mature ecosystem for Flutter

### Why Offline Handling over Search?
- More valuable for real-world mobile apps
- Firebase provides built-in offline support
- Better user experience when connectivity is poor
- Demonstrates understanding of mobile app architecture

### Other Decisions:
- **No complex state management:** Used Provider pattern with StreamBuilder for simplicity
- **Auto-save:** Notes save automatically when navigating back
- **Material Design 3:** Modern, clean UI without custom design complexity
- **Minimal dependencies:** Only essential packages to keep app size small

## Testing the App

### Test Credentials
You can create your own account using any email and password (minimum 6 characters).

### Manual Testing Checklist:
- [ ] Sign up with new account
- [ ] Login with existing account
- [ ] Create notes
- [ ] Edit notes
- [ ] Delete notes
- [ ] Logout and login again
- [ ] Close app and reopen (session persistence)
- [ ] Enable airplane mode and view cached notes
- [ ] Disable airplane mode and see sync

## Known Limitations

- Email verification not implemented (can be added if needed)
- Password reset not implemented (can be added if needed)
- Search functionality not included (chose offline support instead)
- No note categories or tags
- No rich text formatting

## APK Installation

1. Download the APK from the releases or build it using:
   ```bash
   flutter build apk --release
   ```

2. Transfer the APK to your Android device

3. Enable "Install from Unknown Sources" in device settings

4. Install the APK

## License

This project is created for a technical assignment.

## Contact

For questions or issues, please contact the developer.
