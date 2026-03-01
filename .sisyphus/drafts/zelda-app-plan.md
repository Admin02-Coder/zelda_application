# ZELDA Application - Draft Planning Document

## Project Overview
**Application Name**: ZELDA - Real-Time Voice-Activated Emergency Location Streaming & Control Room Dispatch System

**Core Purpose**: Emergency location tracking mobile app with voice activation and police control room dashboard

## UI Design Reference
- Source: E:\stitch_javid_application_ui_design
- Total Screens: 30 screens with Tailwind CSS / dark mode / glassmorphism
- Design Language: Modern dark theme with cyan (#00E0FF) and red (#FF3B3B) accents

## User Roles
1. **Citizen/User**: Regular app users who can trigger emergencies
2. **Police Control Room**: Authorized officers who monitor emergencies

## Technical Requirements

### Frontend
- Framework: Flutter (Dart)
- Target: Android + iOS
- Design: Dark mode glassmorphism following UI design folder

### Backend
- Authentication: Firebase Authentication
- Database: Cloud Firestore (Free tier optimized)
- Push Notifications: Firebase Cloud Messaging (FCM)
- Maps: OpenStreetMap (flutter_map package - free, no API key)

### Key Features
- Track Me toggle with background voice detection
- Manual emergency trigger
- Real-time GPS streaming (optimized: write every 10-15 seconds)
- Emergency session management
- Police control room dashboard with live map
- Role-based access (manual Firestore role assignment)

### Screens to Build (from UI folder)
1. Splash Screen
2. Onboarding Slides (3)
3. OTP Verification
4. User Registration
5. Login
6. Main Dashboard (with SOS button)
7. Active Emergency Status
8. Emergency History
9. Trigger Configuration
10. Recording Settings
11. Notification Settings
12. Security Settings
13. Biometric Setup
14. Add Trusted Contact
15. Trusted Contacts List
16. Nearby SOS Alert
17. Emergency Countdown
18. Alert Message Preview
19. Privacy & Encryption Info
20. About App
21. BLE Mesh Configuration
22. Secure App Lock
23. Detailed Incident Report
24. Network Restored Uploading
25. Successful SOS Relay
26. Upload Successful Confirmation
27. Enable Protection Features

### Police Control Room Screens (Additional)
- Police Login/Registration
- Live Map Dashboard
- Emergency List
- Emergency Details
- Dispatch Controls
- Case Resolution

## Firestore Data Structure
- users/{uid} - User profiles
- emergencies/{emergencyId} - Emergency sessions
- emergencies/{emergencyId}/location_logs - Movement history

## GitHub Repository
- Remote: https://github.com/Admin02-Coder/zelda_application.git
- Already configured with authentication

## Scope Boundaries
- IN: Full Flutter app with all screens
- IN: Firebase integration
- IN: Background services
- IN: Voice detection
- IN: Police dashboard
- EXCLUDE: Cloud Functions (can be added later)
- EXCLUDE: SMS gateway (can be added later)

## Open Questions
- [ ] Exact voice keyword detection approach
- [ ] Battery optimization handling per device
- [ ] Police dispatch workflow details
- [ ] Offline support requirements
