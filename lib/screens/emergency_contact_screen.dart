import 'package:flutter/material.dart';

class EmergencyContactScreen extends StatelessWidget {
  const EmergencyContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kontak Darurat'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
              size: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              'Hubungi Kontak Darurat',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _contactTile(
              icon: Icons.local_hospital,
              title: '119 - Layanan Darurat',
              subtitle: 'Kementerian Kesehatan',
            ),
            _contactTile(
              icon: Icons.local_police,
              title: '110 - Polisi',
              subtitle: 'Kepolisian RI',
            ),
            _contactTile(
              icon: Icons.call,
              title: 'Orang Terdekat',
              subtitle: 'Keluarga / Sahabat',
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text('KEMBALI'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _contactTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.red),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.phone),
        onTap: () {},
      ),
    );
  }
}
