import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'bottom_nav_screen.dart';
import 'firebase_options.dart'; // ✅ Don't forget this!

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Correct initialization using platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Camp Finder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.red.shade700,
          secondary: Colors.red.shade400,
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: isLoggedIn ? const BottomNavScreen() : const LoginPage(),
      routes: {
        '/home': (_) => const BottomNavScreen(),
        '/login': (_) => const LoginPage(),
      },
    );
  }
}
