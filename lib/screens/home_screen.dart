import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HealthySync'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.book),
              label: const Text('Jurnal Harian'),
              onPressed: () {
                Navigator.pushNamed(context, '/journal_list');
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Tambah Jurnal'),
              onPressed: () {
                Navigator.pushNamed(context, '/journal_form');
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.assignment),
              label: const Text('Kuesioner'),
              onPressed: () {
                Navigator.pushNamed(context, '/questionnaire_screen');
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.bar_chart),
              label: const Text('Statistik'),
              onPressed: () {
                Navigator.pushNamed(context, '/stats');
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.emergency),
              label: const Text('Emergency'),
              onPressed: () {
                Navigator.pushNamed(context, '/emergency');
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.settings),
              label: const Text('Pengaturan'),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.person),
              label: const Text('Profil'),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),
      ),
    );
  }
}
