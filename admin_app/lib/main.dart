import 'package:flutter/material.dart';
import 'package:admin_app/screens/starting_screen.dart'; // ✅ 분리한 화면 import

void main() => runApp(const AdminApp());

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0E2C4A);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: navy),
        textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16)),
      ),
      home: const StartingScreen(),
    );
  }
}
