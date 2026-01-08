# Firebase Configuration Setup

This file is a placeholder. You need to configure Firebase for this project.

## Steps to Configure Firebase:

1. **Create a Firebase Project:**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Click "Add project"
   - Follow the setup wizard

2. **Enable Authentication:**
   - In Firebase Console, go to Authentication
   - Click "Get Started"
   - Enable "Email/Password" sign-in method

3. **Create Firestore Database:**
   - In Firebase Console, go to Firestore Database
   - Click "Create database"
   - Start in **test mode** for development (you'll add security rules later)
   - Choose a location

4. **Add Android App:**
   - In Project Settings, click "Add app" and select Android
   - Package name: `com.example.flutter_notes_app`
   - Download `google-services.json`
   - Place it in: `android/app/google-services.json`

5. **Add Firestore Security Rules:**
   In Firestore Database > Rules, add:
   ```
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

6. **Run the app:**
   ```bash
   flutter pub get
   flutter run
   ```

## Important:
- The `google-services.json` file is required for the app to work
- Without it, Firebase initialization will fail
- This file should NOT be committed to public repositories (it's in .gitignore)
