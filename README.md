# Android Event Booking Flutter App

This is a Flutter app for booking and managing events. Users can view events, book tickets, and manage their personal profiles. The app integrates with Firebase for user authentication and data storage.

## Features

- **User Authentication**: Sign up and log in using Firebase Authentication.
- **Event Listings**: View available events and their details.
- **Event Booking**: Users can book tickets for events.
- **Profile Management**: Users can view and update their profile information (Name, Email, Phone, Bio).
- **Firebase Integration**: All user and event data are managed via Firebase Firestore.

## Screens

1. **Event Listings**: 
   - Display a list of events.
   - Each event has details such as name, date, and description.
   - Button to view event details and book tickets.

2. **Event Booking**:
   - Option to book tickets for a selected event.
   - Displays available slots or tickets left.

3. **Profile View**:
   - Displays user profile information (Name, Email, Phone, Bio).
   - Option to navigate to the profile edit screen.

4. **Edit Profile**:
   - Text fields for updating name, phone number, and bio.
   - Option to update the profile in Firebase.

## Dependencies

- `firebase_auth`: Firebase Authentication for user login and sign-up.
- `cloud_firestore`: Firebase Firestore for storing user and event data.
- `firebase_core`: Initializes Firebase services in the app.
- `flutter`: For app development.

## Setup Instructions

1. Clone this repository to your local machine:
   ```bash
   git clone https://github.com/ibtyhel25/my-events.git
   ```
2. Ensure that you have Flutter and Firebase set up in your project.
4. Install necessary dependencies by running:
   ```bash
   flutter pub get
   ```
5. Set up Firebase for your Flutter project by following the Firebase setup guide.
6. Add Firebase configuration files (e.g., google-services.json for Android) to your project.
7. Run the app on your device or emulator:
   ```bash
   flutter run
   ```
   
##App Structure

`lib/screens`: Contains UI screens like event listing, event details, profile view, and profile edit.
`lib/services`: Contains services for Firebase operations (authentication, event management, profile management).
`lib/models`: Contains data models for events and profiles.
   
