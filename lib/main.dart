import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'register.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'frontend.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,); // ✅ Firebase initialized here only
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return MaterialApp(

      title: 'Firebase Registration',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: currentUser != null ? const MyHomePage(title: 'Calculator',) : const RegisterScreen(),
    );
  }
}