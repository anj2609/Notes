# Notes - Flutter Firebase Application

> **Technical Assignment Submission**  
> A simple, secure notes application built with Flutter and Firebase demonstrating authentication, CRUD operations, and offline support.

[![Flutter](https://img.shields.io/badge/Flutter-3.35.7-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Latest-FFCA28?logo=firebase)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📱 Download APK

**[Download app-release.apk (46.6 MB)](https://github.com/anj2609/Notes/releases/download/v1.0.0/app-release.apk)**

Or find it in the repository: `build/app/outputs/flutter-apk/app-release.apk`

---

## ✨ Features Implemented

### ✅ Authentication
- Email/password sign up with validation
- Email/password login
- Logout with confirmation dialog
- **Session persistence** - Users stay logged in after app restart
- User-friendly error messages

### ✅ Notes CRUD Operations
- **Create** notes with title and content
- **Read** notes list with real-time updates
- **Update** notes with auto-save functionality
- **Delete** notes with confirmation dialog
- Notes sorted by last updated (newest first)

### ✅ Security & Data Isolation
- Firestore security rules enforce user-specific access
- Client-side filtering by `userId`
- **Users can ONLY access their own notes**
- Server-side and client-side validation

### ✅ Offline Handling (Additional Feature)
- Firestore offline persistence enabled
- Cached data available when offline
- Error states for connectivity issues
- Automatic sync when connection restored
- App doesn't crash without internet

### ✅ Clean UI/UX
- Material Design 3 interface
- Professional indigo/purple color scheme
- Loading, empty, and error states
- No layout overflow issues
- Responsive design

---

## 🛠 Tech Stack

- **Framework**: Flutter 3.35.7
- **Backend**: Firebase
  - Authentication: Email/Password
  - Database: Cloud Firestore
  - Offline: Firestore Persistence
- **State Management**: StreamBuilder + Provider pattern
- **Dependencies**:
  ```yaml
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.4
  provider: ^6.1.1
  intl: ^0.18.1
  ```

---

## 📋 Prerequisites

Before running this app, ensure you have:

- Flutter SDK (3.0.0 or higher)
- Android Studio or VS Code with Flutter extensions
- Android device or emulator (API level 21+)
- Firebase account (for backend configuration)

---

## 🚀 Project Setup

### 1. Clone the Repository

```bash
git clone https://github.com/anj2609/Notes.git
cd Notes
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Firebase Configuration

This project requires Firebase setup. Follow these steps:

#### Option A: Use Existing Configuration (For Testing)
The repository includes a pre-configured `google-services.json` file. You can use it for testing purposes.

#### Option B: Set Up Your Own Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Enable **Email/Password Authentication**
4. Create a **Firestore Database** in test mode
5. Add an Android app with package name: `com.example.flutter_notes_app`
6. Download `google-services.json` and place it in `android/app/`
7. Add the following Firestore security rules:

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

**Detailed setup guide**: See [FIREBASE_SETUP.md](FIREBASE_SETUP.md)

### 4. Run the App

```bash
# Run on connected device/emulator
flutter run

# Or build APK
flutter build apk --release
```

---

## 📊 Database Schema

### Collection: `notes`

| Field | Type | Description |
|-------|------|-------------|
| `id` | String | Auto-generated document ID |
| `title` | String | Note title |
| `content` | String | Note content |
| `createdAt` | Timestamp | Creation timestamp |
| `updatedAt` | Timestamp | Last update timestamp |
| `userId` | String | Firebase Auth UID (for data isolation) |

### Example Document

```json
{
  "id": "abc123",
  "title": "My First Note",
  "content": "This is the content of my note",
  "createdAt": "2024-01-08T10:30:00Z",
  "updatedAt": "2024-01-08T15:45:00Z",
  "userId": "firebase_auth_uid_here"
}
```

---

## 🔐 Authentication Approach

### Implementation Details

1. **Firebase Authentication** with email/password provider
2. **Session Persistence**: 
   - Uses Firebase's built-in `authStateChanges()` stream
   - Automatically restores user session on app restart
   - No manual token management required

3. **Auth Flow**:
   ```
   App Start → Check Auth State → Logged In? → Notes Screen
                                            ↓
                                         Login Screen
   ```

4. **Security**:
   - Passwords validated (minimum 6 characters)
   - Email format validation
   - Error handling for all auth operations
   - User-friendly error messages (no raw backend errors)

---

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry, Firebase init, theme
├── models/
│   └── note_model.dart         # Note data model with serialization
├── services/
│   ├── auth_service.dart       # Authentication logic
│   └── notes_service.dart      # Firestore CRUD operations
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart   # Login UI
│   │   └── signup_screen.dart  # Signup UI
│   └── notes/
│       ├── notes_list_screen.dart    # Notes list with real-time updates
│       └── note_editor_screen.dart   # Create/edit notes
├── widgets/
│   └── note_card.dart          # Reusable note list item
└── utils/
    └── constants.dart          # App-wide constants (colors, spacing)
```

---

## 🎯 Assumptions & Trade-offs

### Assumptions
1. **Email verification not required** - Users can sign up without email verification
2. **Simple note structure** - No categories, tags, or rich text formatting
3. **Single device usage** - No conflict resolution for simultaneous edits
4. **Test mode Firestore** - Suitable for development and demonstration

### Trade-offs
1. **Offline Handling over Search** - Chose offline support as it's more critical for mobile apps
2. **Client-side sorting** - Removed Firestore `.orderBy()` to avoid composite index requirement
3. **No password reset** - Not implemented to focus on core features
4. **Public API key** - Firebase API keys are safe to be public (security is in Firestore rules)

### Why Firebase over Supabase?
- Better Flutter integration with official packages
- Simpler authentication setup
- Built-in offline persistence
- Easier security rules syntax
- More mature ecosystem

---

## 🧪 Testing Instructions

### Manual Testing Checklist

#### Authentication
- [ ] Sign up with new email/password
- [ ] Verify user appears in Firebase Console
- [ ] Login with credentials
- [ ] Logout and login again
- [ ] Close app completely and reopen (session should persist)

#### CRUD Operations
- [ ] Create a note with title and content
- [ ] View note in list
- [ ] Edit note and verify auto-save
- [ ] Delete note with confirmation
- [ ] Create multiple notes and verify sorting

#### Data Isolation
- [ ] Create notes with User A
- [ ] Logout and create User B
- [ ] Verify User B cannot see User A's notes

#### Offline Functionality
- [ ] Create notes while online
- [ ] Enable airplane mode
- [ ] View cached notes (should work)
- [ ] Disable airplane mode
- [ ] Verify changes sync

---

## 📦 APK Installation

### Download & Install

1. **Download APK**: Get `app-release.apk` from releases or repository
2. **Enable Unknown Sources**: 
   - Go to Settings → Security
   - Enable "Install from unknown sources"
3. **Install**: Open the APK file and tap "Install"
4. **Launch**: Open "Notes" app from your app drawer

### Test Credentials

You can create any test account:
- Email: `test@example.com` (or any email format)
- Password: `test123` (minimum 6 characters)

---

## 🐛 Known Limitations

- Email verification not implemented
- Password reset functionality not included
- No search functionality (chose offline support instead)
- No note categories or tags
- No rich text formatting
- No note sharing between users

---

## 📝 Code Quality

- ✅ **Flutter Analyze**: No issues found
- ✅ **No deprecated APIs**: All deprecations fixed
- ✅ **Clean Architecture**: Separation of concerns (models, services, screens, widgets)
- ✅ **Error Handling**: User-friendly error messages throughout
- ✅ **Null Safety**: Full null safety compliance

---

## 🔒 Security Notes

### Firebase API Key in Repository
The `google-services.json` file contains a Firebase API key. This is **intentional and safe**:

- Firebase API keys are meant to be public in client applications
- Real security is enforced by **Firestore Security Rules**
- The rules ensure users can only access their own data
- This is standard practice for Firebase applications

### Firestore Security Rules
```javascript
// Users can only read/write their own notes
allow read, write: if request.auth != null 
  && request.auth.uid == resource.data.userId;
```

---

## 📄 License

This project is created for a technical assignment and is available under the MIT License.

---

## 👤 Author

**Anjali Gupta**
- GitHub: [@anj2609](https://github.com/anj2609)
- Email: anjaligupta25092005@gmail.com

---

## 🙏 Acknowledgments

- Flutter team for excellent documentation
- Firebase for robust backend services
- Technical assignment for clear requirements

---

**Built with ❤️ using Flutter & Firebase**
