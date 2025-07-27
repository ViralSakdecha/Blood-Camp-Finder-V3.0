import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'auth_page.dart';
import 'bottom_nav_screen.dart';
import 'firebase_options.dart';
import 'services/connectivity_service.dart';
import 'no_internet_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ConnectivityService.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Bank',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: StreamBuilder<ConnectivityResult>(
        stream: ConnectivityService.instance.connectivityStream,
        initialData: ConnectivityResult.mobile,
        builder: (context, snapshot) {
          if (snapshot.data == ConnectivityResult.none) {
            return const NoInternetScreen();
          }
          // This is the new authentication gatekeeper logic
          return const AuthGate();
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

// This new widget is the gatekeeper for your app's authentication state.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show a loading indicator while waiting for Firebase to initialize.
        // This prevents the screen from flashing.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B6B)),
              ),
            ),
          );
        }

        // If the snapshot has data, a user is logged in.
        if (snapshot.hasData) {
          return const BottomNavScreen(); // Go to the main app screen
        }
        // Otherwise, no user is logged in.
        else {
          return const AuthPage(); // Go to the login/register screen
        }
      },
    );
  }
}
