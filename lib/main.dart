import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'bottom_nav_screen.dart'; // Your existing home screen
import 'firebase_options.dart';
import 'services/connectivity_service.dart'; // Import the service
import 'no_internet_screen.dart';   // Import the new screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize your connectivity service
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
      // Use a StreamBuilder to check for internet connection
      home: StreamBuilder<ConnectivityResult>(
        stream: ConnectivityService.instance.connectivityStream,
        initialData: ConnectivityResult.mobile, // Assume connection initially
        builder: (context, snapshot) {
          if (snapshot.data == ConnectivityResult.none) {
            // If no internet, show the NoInternetScreen
            return const NoInternetScreen();
          } else {
            // If there is a connection, show your main app screen
            return const BottomNavScreen();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
