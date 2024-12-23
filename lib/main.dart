import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled/screens/create_profile_screen.dart';
import 'package:untitled/screens/edit-profile_screen.dart';
import 'package:untitled/screens/profile_view_screen.dart';
import 'firebase_options.dart';
import 'models/event.dart';
import 'screens/landing_screen.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/create_event_screen.dart';
import 'screens/update_event_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Booking App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/' : '/home',
      routes: {
        '/': (context) => LandingScreen(),  // Landing screen if user is not logged in
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/create-profile': (context) => CreateProfileScreen(),
        '/profile-view': (context) => ProfileViewScreen(),
        '/profile-edit': (context) => EditProfileScreen(),
        '/home': (context) => HomeScreen(userId: FirebaseAuth.instance.currentUser?.uid ?? ''),  // Pass userId to HomeScreen
        '/create-event': (context) => CreateEventScreen(userId: FirebaseAuth.instance.currentUser?.uid ?? ''),
        '/update-event': (context) => UpdateEventScreen(event: ModalRoute.of(context)!.settings.arguments as Event,userId: FirebaseAuth.instance.currentUser?.uid ?? ''),
      },
    );
  }
}
