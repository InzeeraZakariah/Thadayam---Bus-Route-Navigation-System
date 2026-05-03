import 'package:flutter/material.dart';
import 'theme.dart';
import 'pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBlmUBb33JdTJQxpfbj4DDrlYetaSbrXP8",
      authDomain: "busdiscoveryapp.firebaseapp.com",
      projectId: "busdiscoveryapp",
      storageBucket: "busdiscoveryapp.firebasestorage.app",
      messagingSenderId: "975599685560",
      appId: "1:975599685560:web:63a9e8ae5c3ea2c3a1494d",
      measurementId: "G-J5G07DBS9N",
    ),
  );
  runApp(BusNav());
}

class BusNav extends StatelessWidget {
  const BusNav({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: LoginPage(),
    );
  }
}
