import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  // Simulasi loading sebelum masuk ke Login/Home
  void _navigateToLogin() async {
    // Menambahkan tipe data eksplisit pada Future
    await Future<void>.delayed(const Duration(seconds: 3));

    // Memperbaiki posisi statement agar berada di baris baru
    if (!mounted) {
      return;
    }

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // Menambahkan tipe data eksplisit pada list children
          children: <Widget>[
            Icon(Icons.health_and_safety, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              'HealthySync',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
