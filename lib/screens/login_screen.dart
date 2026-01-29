import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login HealthySync'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.spa_rounded,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              const Text(
                'Selamat Datang',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Mulai perjalanan kesehatan jiwamu hari ini.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),

              /// KE BERANDA
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('MASUK KE BERANDA'),
              ),

              const SizedBox(height: 15),

              /// TEST EMERGENCY
              OutlinedButton.icon(
                icon: const Icon(Icons.emergency),
                label: const Text('TEST EMERGENCY CONTACT'),
                onPressed: () {
                  NotificationService().showEmergencyNotification(
                    'Kondisi Darurat',
                    'Tap untuk menghubungi kontak darurat',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
