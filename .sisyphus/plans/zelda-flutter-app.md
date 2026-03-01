# ZELDA - Emergency Location System Work Plan

## TL;DR

> **Quick Summary**: Flutter mobile application for emergency location streaming with voice activation and police control room dashboard. Built on Firebase (free tier optimized) with OpenStreetMap integration.

> **Deliverables**:
> - Complete Flutter app (30+ screens)
> - Firebase Authentication & Firestore integration
> - Background location & voice detection services
> - Police Control Room dashboard with live map
> - GitHub repository with working code

> **Estimated Effort**: XL (Large multi-month project)
> **Parallel Execution**: YES - Multiple waves with 5-8 tasks per wave
> **Critical Path**: Project setup → Core services → User features → Police dashboard → Integration

---

## Context

### Original Request
Build ZELDA - Real-Time Voice-Activated Emergency Location Streaming & Control Room Dispatch Mobile System using Flutter + Firebase. Use UI designs from `E:\stitch_javid_application_ui_design` folder.

### Design System Analysis
**UI Source**: 30 screens with Tailwind CSS patterns
- Dark mode glassmorphism design
- Primary colors: Cyan (#00E0FF), Red (#FF3B3B), Navy background (#0B1120)
- Material Symbols icons
- Space Grotesk & Inter fonts

### Technical Requirements
- **Framework**: Flutter (Dart)
- **Backend**: Firebase (Auth, Firestore, FCM)
- **Maps**: OpenStreetMap via flutter_map (free, no API key)
- **Background**: geolocator + flutter_background_service
- **Voice**: speech_to_text for keyword detection

### Roles
1. **User/Citizen**: Regular users who trigger emergencies
2. **Police Control Room**: Authorized monitors with role-based access

---

## Work Objectives

### Core Objective
Build a production-ready emergency location tracking system with:
- Voice-activated and manual emergency triggers
- Real-time GPS streaming (optimized for Firestore free tier)
- Police control room dashboard
- Role-based security

### Concrete Deliverables
- Flutter project with pubspec.yaml and dependencies
- 30+ UI screens matching design folder
- Firebase configuration and security rules
- Background services for location tracking
- Voice keyword detection system
- Police dashboard with live map
- Git repository with commit history

### Definition of Done
- [ ] All 30+ screens implemented and navigable
- [ ] Firebase Authentication working (email/password)
- [ ] Firestore CRUD operations functional
- [ ] Real-time location streaming (10-15 sec intervals)
- [ ] Voice keyword detection operational
- [ ] Police dashboard with map markers
- [ ] Security rules enforce role-based access
- [ ] Builds successfully on Android/iOS

### Must Have
- Emergency trigger (manual + voice)
- Background location tracking
- Real-time map for police
- Push notification support
- Role-based authentication

### Must NOT Have
- SMS functionality (out of scope)
- Cloud Functions (can add later)
- Admin panel (role manually set in Firestore)
- Third-party maps requiring API keys

---

## Verification Strategy

### Test Decision
- **Infrastructure exists**: NO - New Flutter project
- **Automated tests**: Tests-after (unit tests after implementation)
- **Framework**: flutter_test (built-in)

### QA Policy
Every task includes Agent-Executed QA Scenarios:
- **UI Verification**: Playwright-like tests via flutter test
- **Backend Verification**: Firebase Emulator tests
- **Integration**: Manual testing via debug APK

---

## Execution Strategy

### Wave Structure

```
Wave 1 (Foundation - can start immediately):
├── T1: Flutter project initialization + pubspec.yaml
├── T2: Design system constants (colors, fonts, themes)
├── T3: Firebase configuration + google-services.json
├── T4: Core navigation setup (GoRouter)
├── T5: Authentication screens (Login, Register, OTP)
├── T6: Splash + Onboarding screens (3 slides)
└── T7: Shared UI components (buttons, cards, glass panels)

Wave 2 (User Core Features):
├── T8: Main Dashboard with SOS button
├── T9: Track Me toggle service
├── T10: Background location service setup
├── T11: Voice detection service
├── T12: Emergency trigger logic
├── T13: Active Emergency Status screen
└── T14: Emergency History screen

Wave 3 (Settings & Contacts):
├── T15: Trigger Configuration screen
├── T16: Recording Settings screen
├── T17: Notification Settings screen
├── T18: Security Settings screen
├── T19: Biometric Setup screen
├── T20: Trusted Contacts List screen
├── T21: Add Trusted Contact screen
└── T22: App Lock screen

Wave 4 (Additional Screens):
├── T23: Privacy & Encryption Info screen
├── T24: About App screen
├── T25: BLE Mesh Configuration screen
├── T26: Emergency Countdown screen
├── T27: Alert Message Preview screen
├── T28: Nearby SOS Alert screen
├── T29: Network Restored Uploading screen
└── T30: Successful SOS Relay screen

Wave 5 (Police Control Room):
├── T31: Police Login/Registration
├── T32: Police Dashboard with Stats Cards
├── T33: Live Map with markers
├── T34: Emergency List (bottom panel)
├── T35: Emergency Details screen
├── T36: Dispatch workflow
└── T37: Case Resolution

Wave 6 (Backend & Integration):
├── T38: Firestore security rules
├── T39: FCM push notification setup
├── T40: Location write optimization
├── T41: User-Police role management
└── T42: Final build verification
```

---

## TODOs

> Implementation + Test = ONE Task. Every task has Agent Profile + QA Scenarios.

---

## Wave 1: Foundation Tasks

- [ ] 1. **Flutter Project Initialization**

  **What to do**:
  - Create Flutter project in E:\zelda_application
  - Set up pubspec.yaml with all dependencies:
    - firebase_core, firebase_auth, cloud_firestore
    - flutter_map, latlong2
    - geolocator, flutter_background_service
    - speech_to_text
    - go_router (navigation)
    - flutter_secure_storage
    - permission_handler
    - intl (internationalization)
  - Create directory structure

  **Must NOT do**:
  - Add native code modifications yet

  **Recommended Agent Profile**:
  - **Category**: `quick`
  - **Skills**: [`flutter`, `dart`]

  **Parallelization**:
  - Can Run In Parallel: YES (with tasks 2,3,4,7)
  - Wave: 1
  - Blocks: Tasks 5,6

  **References**:
  - Flutter pub.dev for latest package versions
  - Firebase Flutter setup docs

  **Acceptance Criteria**:
  - [ ] flutter create zelda_app runs successfully
  - [ ] Dependencies resolve without conflicts
  - [ ] Basic app builds to APK

  **QA Scenarios**:
  - Run `flutter pub get` - should succeed
  - Run `flutter build apk --debug` - should compile

- [ ] 2. **Design System Constants**

  **What to do**:
  - Create lib/theme/app_colors.dart with:
    - Primary: #00E0FF (Cyan)
    - Secondary/Alert: #FF3B3B (Red)
    - Background Dark: #0B1120
    - Background Light: #F8F5F5
    - Glass effects
  - Create app_typography.dart with fonts
  - Create app_theme.dart with dark theme

  **Must NOT do**:
  - Hardcode colors in widgets

  **Recommended Agent Profile**:
  - **Category**: `quick`
  - **Skills**: [`flutter`]

  **Parallelization**:
  - Can Run In Parallel: YES (Wave 1)
  - Blocks: All UI tasks

  **References**:
  - UI folder: code.html files for exact color values
  - Tailwind config in onboarding screens

  **Acceptance Criteria**:
  - [ ] Theme class accessible from main.dart
  - [ ] Colors match UI design exactly

- [ ] 3. **Firebase Configuration**

  **What to do**:
  - Add google-services.json (placeholder)
  - Initialize Firebase in main.dart
  - Create firebase_options.dart
  - Configure Firebase Auth and Firestore

  **Recommended Agent Profile**:
  - **Category**: `quick`
  - **Skills**: [`firebase-development`]

  **Parallelization**:
  - Can Run In Parallel: YES (Wave 1)

  **References**:
  - Firebase Flutter setup documentation

  **Acceptance Criteria**:
  - [ ] Firebase initializes without error
  - [ ] Auth and Firestore services available

- [ ] 4. **Navigation Setup (GoRouter)**

  **What to do**:
  - Install go_router
  - Create app_router.dart
  - Define routes for all screens
  - Set up route guards (auth check)
  - Create splash → onboarding → auth flow

  **Recommended Agent Profile**:
  - **Category**: `quick`
  - **Skills**: [`flutter`]

  **Parallelization**:
  - Can Run In Parallel: YES (Wave 1)

  **References**:
  - GoRouter Flutter documentation

  **Acceptance Criteria**:
  - [ ] All routes defined
  - [ ] Navigation works between screens

- [ ] 5. **Authentication Screens**

  **What to do**:
  - Create Login screen (email/password)
  - Create Register screen with form validation
  - Create OTP Verification screen
  - Implement Firebase Auth integration
  - Create AuthController/BLoC

  **Recommended Agent Profile**:
  - **Category**: `visual-engineering`
  - **Skills**: [`flutter`, `frontend-design`]

  **Parallelization**:
  - Can Run In Parallel: YES (with T6, T7)
  - Blocked By: T1, T4

  **References**:
  - secure_user_registration_screen/code.html
  - otp_verification_screen/code.html

  **Acceptance Criteria**:
  - [ ] User can register with email
  - [ ] User can login
  - [ ] OTP verification flow works

  **QA Scenarios**:
  - Create account → verify in Firebase Console
  - Login → should redirect to dashboard

- [ ] 6. **Splash + Onboarding**

  **What to do**:
  - Create Splash screen with app logo
  - Create Onboarding screen (3 slides)
  - Slide 1: Instant Activation
  - Slide 2: Offline Protection
  - Slide 3: Secure Evidence

  **Recommended Agent Profile**:
  - **Category**: `visual-engineering`
  - **Skills**: [`flutter`, `frontend-design`]

  **References**:
  - safety_app_splash_screen/code.html
  - onboarding_slide_1/2/3/code.html

  **Acceptance Criteria**:
  - [ ] Splash shows on app launch
  - [ ] Onboarding shows 3 slides
  - [ ] Navigation to login after onboarding

- [ ] 7. **Shared UI Components**

  **What to do**:
  - Create GlassCard widget (glassmorphism)
  - Create PrimaryButton widget
  - Create CustomTextField widget
  - Create StatusIndicator widget
  - Create SOSButton widget (pulsing)

  **Recommended Agent Profile**:
  - **Category**: `quick`
  - **Skills**: [`flutter`]

  **References**:
  - Glassmorphism CSS from code.html files

  **Acceptance Criteria**:
  - [ ] Reusable components work
  - [ ] Match design exactly

---

## Wave 2: User Core Features

- [ ] 8. **Main Dashboard with SOS Button**

  **What to do**:
  - Implement main_emergency_dashboard_screen design
  - Large pulsing SOS button
  - Track Me toggle
  - Status indicators (GPS, Network, BLE)
  - Bottom navigation

  **Recommended Agent Profile**:
  - **Category**: `visual-engineering`
  - **Skills**: [`flutter`, `frontend-design`]

  **References**:
  - main_emergency_dashboard_screen/code.html

  **Acceptance Criteria**:
  - [ ] SOS button has pulsing animation
  - [ ] Toggle switches work
  - [ ] Status indicators show

- [ ] 9. **Track Me Service**

  **What to do**:
  - Create TrackMeController
  - Implement enable/disable logic
  - Handle permission requests
  - Persist state in secure storage

  **References**:
  - Architecture spec: Track Me toggle ON/OFF

  **Acceptance Criteria**:
  - [ ] Toggle updates UI state
  - [ ] State persists across app restart

- [ ] 10. **Background Location Service**

  **What to do**:
  - Set up geolocator package
  - Configure foreground service notification
  - Implement location tracking loop
  - Optimize for Firestore writes (10-15 sec)

  **Recommended Agent Profile**:
  - **Category**: `unspecified-high`
  - **Skills**: [`flutter`, `mobile-development`]

  **References**:
  - geolocator package documentation
  - Android foreground service requirements

  **Acceptance Criteria**:
  - [ ] Location updates when enabled
  - [ ] Service runs in background
  - [ ] Battery optimized

- [ ] 11. **Voice Detection Service**

  **What to do**:
  - Implement speech_to_text
  - Create keyword detection logic
  - Handle microphone permissions
  - Local processing (no cloud)

  **References**:
  - speech_to_text package

  **Acceptance Criteria**:
  - [ ] Detects configured keyword
  - [ ] Works in background when enabled

- [ ] 12. **Emergency Trigger Logic**

  **What to do**:
  - Create EmergencyController
  - Implement manual trigger
  - Implement voice trigger
  - Create emergency document in Firestore
  - Trigger push notification

  **References**:
  - Emergency workflow from spec

  **Acceptance Criteria**:
  - [ ] Manual trigger creates Firestore doc
  - [ ] Voice trigger creates Firestore doc
  - [ ] FCM notification sent

- [ ] 13. **Active Emergency Status Screen**

  **What to do**:
  - Build active_emergency_status_screen UI
  - Display timer, location, battery
  - Show live map preview
  - Stop emergency button

  **References**:
  - active_emergency_status_screen/code.html

  **Acceptance Criteria**:
  - [ ] Timer counts up
  - [ ] Location displays
  - [ ] Stop button ends emergency

- [ ] 14. **Emergency History Screen**

  **What to do**:
  - Build emergency_history_screen
  - List past emergencies
  - Show trigger type, duration, status

  **References**:
  - emergency_history_screen/code.html

  **Acceptance Criteria**:
  - [ ] Shows list of past emergencies
  - [ ] Tappable to view details

---

## Wave 3: Settings & Contacts

- [ ] 15. **Trigger Configuration Screen**

  **What to do**:
  - Configure secret keyword
  - Set trigger sensitivity
  - Test voice detection

  **References**:
  - trigger_configuration_screen/code.html

- [ ] 16. **Recording Settings Screen**

  **What to do**:
  - Audio recording options
  - Video capture settings

  **References**:
  - recording_settings_screen/code.html

- [ ] 17. **Notification Settings Screen**

  **What to do**:
  - Push notification preferences
  - Alert sounds toggle

  **References**:
  - notification_settings_screen/code.html

- [ ] 18. **Security Settings Screen**

  **What to do**:
  - PIN setup
  - Biometric toggle
  - App lock settings

  **References**:
  - security_settings_screen/code.html

- [ ] 19. **Biometric Setup Screen**

  **What to do**:
  - Fingerprint/face enrollment
  - Enable/disable biometric

  **References**:
  - biometric_security_setup_screen/code.html

- [ ] 20. **Trusted Contacts List Screen**

  **What to do**:
  - Display list of trusted contacts
  - Add/edit/delete contacts

  **References**:
  - trusted_contacts_list_screen/code.html

- [ ] 21. **Add Trusted Contact Screen**

  **What to do**:
  - Add new contact form
  - Phone number input
  - Relationship field

  **References**:
  - add_trusted_contact_screen/code.html

- [ ] 22. **App Lock Screen**

  **What to do**:
  - PIN entry screen
  - Biometric prompt

  **References**:
  - secure_app_lock_screen/code.html

---

## Wave 4: Additional Screens

- [ ] 23. **Privacy & Encryption Info Screen**

  **What to do**:
  - Display privacy policy
  - Encryption details

  **References**:
  - privacy_and_encryption_info_screen/code.html

- [ ] 24. **About App Screen**

  **What to do**:
  - App version
  - Credits
  - Links

  **References**:
  - about_app_screen/code.html

- [ ] 25. **BLE Mesh Configuration Screen**

  **What to do**:
  - BLE device pairing
  - Mesh network setup

  **References**:
  - ble_mesh_configuration_screen/code.html

- [ ] 26. **Emergency Countdown Screen**

  **What to do**:
  - Countdown timer before trigger
  - Cancel option

  **References**:
  - emergency_countdown_screen/code.html

- [ ] 27. **Alert Message Preview Screen**

  **What to do**:
  - Preview emergency message
  - Edit before sending

  **References**:
  - alert_message_preview_screen/code.html

- [ ] 28. **Nearby SOS Alert Screen**

  **What to do**:
  - Show nearby emergencies
  - Alert notifications

  **References**:
  - nearby_sos_alert_screen/code.html

- [ ] 29. **Network Restored Uploading Screen**

  **What to do**:
  - Upload queued data when online
  - Progress indicator

  **References**:
  - network_restored__uploading_screen/code.html

- [ ] 30. **Successful SOS Relay Screen**

  **What to do**:
  - Confirmation UI
  - Next steps

  **References**:
  - successful_sos_relay_screen/code.html

---

## Wave 5: Police Control Room

- [ ] 31. **Police Login/Registration**

  **What to do**:
  - Separate login for police
  - Badge number verification
  - Secret code validation

  **Acceptance Criteria**:
  - [ ] Police can register
  - [ ] Role stored as "police" in Firestore

- [ ] 32. **Police Dashboard Stats**

  **What to do**:
  - Total alerts today
  - Active emergencies
  - Resolved cases
  - Voice vs manual counts

  **Acceptance Criteria**:
  - [ ] Stats update in real-time
  - [ ] Cards match design

- [ ] 33. **Live Map with Markers**

  **What to do**:
  - OpenStreetMap integration
  - Show all active emergencies
  - Color-coded by severity
  - Real-time marker updates

  **References**:
  - flutter_map package
  - OpenStreetMap tiles

  **Acceptance Criteria**:
  - [ ] Map displays correctly
  - [ ] Markers show active emergencies
  - [ ] Markers update in real-time

- [ ] 34. **Emergency List Panel**

  **What to do**:
  - Bottom sheet with emergency list
  - Sort by severity/duration
  - Show victim details
  - Battery/network status

  **Acceptance Criteria**:
  - [ ] List shows all active cases
  - [ ] Tappable to view details

- [ ] 35. **Emergency Details Screen**

  **What to do**:
  - Full victim information
  - Live coordinates
  - Movement history trail
  - Call victim button

  **Acceptance Criteria**:
  - [ ] All details display
  - [ ] Map trail shows movement

- [ ] 36. **Dispatch Workflow**

  **What to do**:
  - Mark as dispatched
  - Contact nearest police
  - Status updates

  **Acceptance Criteria**:
  - [ ] Status changes to dispatched
  - [ ] Notification sent

- [ ] 37. **Case Resolution**

  **What to do**:
  - Mark as resolved
  - End location streaming
  - Generate report

  **Acceptance Criteria**:
  - [ ] Status changes to resolved
  - [ ] User notified

---

## Wave 6: Backend & Integration

- [ ] 38. **Firestore Security Rules**

  **What to do**:
  - Users can read/write own profile
  - Users can create own emergencies
  - Police can read all emergencies
  - Only police can update status
  - No public access

  **Acceptance Criteria**:
  - [ ] Rules tested and secure

- [ ] 39. **FCM Push Notifications**

  **What to do**:
  - Set up FCM for new emergencies
  - Handle notification taps
  - Background handling

  **Acceptance Criteria**:
  - [ ] Notifications received
  - [ ] Tap opens correct screen

- [ ] 40. **Location Write Optimization**

  **What to do**:
  - Implement 10-15 second write interval
  - Batch location logs in subcollection
  - Monitor Firestore usage

  **Acceptance Criteria**:
  - [ ] Under free tier limits
  - [ ] Real-time updates work

- [ ] 41. **Role Management**

  **What to do**:
  - User role defaults to "user"
  - Police role manually set in Firestore
  - Login flow checks role
  - Redirects to correct dashboard

  **Acceptance Criteria**:
  - [ ] Users see user dashboard
  - [ ] Police see control room

- [ ] 42. **Final Build Verification**

  **What to do**:
  - Debug APK build
  - Test all flows
  - GitHub push

  **Acceptance Criteria**:
  - [ ] APK builds successfully
  - [ ] All screens navigable

---

## Final Verification Wave

- [ ] F1. **Plan Compliance Audit** — `oracle`

- [ ] F2. **Code Quality Review** — `unspecified-high`

- [ ] F3. **Integration Testing** — `unspecified-high`

- [ ] F4. **Scope Fidelity Check** — `deep`

---

## Commit Strategy

- Wave 1: `chore: Flutter project setup`
- Wave 2: `feat: Core emergency features`
- Wave 3: `feat: Settings and contacts`
- Wave 4: `feat: Additional UI screens`
- Wave 5: `feat: Police control room`
- Wave 6: `fix: Backend integration`
- Final: `release: v1.0.0`

---

## Success Criteria

### Verification Commands
```bash
flutter pub get  # Dependencies resolve
flutter analyze  # No errors
flutter build apk --debug  # APK builds
```

### Final Checklist
- [ ] All 30+ screens implemented
- [ ] Firebase integration working
- [ ] Background location functional
- [ ] Voice detection operational
- [ ] Police dashboard complete
- [ ] Security rules enforced
- [ ] Builds successfully
- [ ] Pushed to GitHub
