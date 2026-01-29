import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        // PERBAIKAN: Menambahkan tipe data eksplisit <Widget>
        children: <Widget>[
          _buildItem(
            icon: Icons.person,
            title: 'Profil',
            subtitle: 'Kelola informasi akun',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur profil belum tersedia')),
              );
            },
          ),
          _buildItem(
            icon: Icons.notifications,
            title: 'Notifikasi',
            subtitle: 'Atur pengingat & peringatan',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur notifikasi belum tersedia'),
                ),
              );
            },
          ),
          _buildItem(
            icon: Icons.dark_mode,
            title: 'Mode Gelap',
            subtitle: 'Aktifkan tampilan gelap',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mode gelap coming soon')),
              );
            },
          ),
          const Divider(height: 32),
          _buildItem(
            icon: Icons.info,
            title: 'Tentang Aplikasi',
            subtitle: 'HealthySync v1.0',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'HealthySync',
                applicationVersion: '1.0.0',
                applicationLegalese: 'Aplikasi jurnal kesehatan mental pribadi',
              );
            },
          ),
          _buildItem(
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Keluar dari akun',
            iconColor: Colors.red,
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                // PERBAIKAN: Menambahkan tipe data Route<dynamic>
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color iconColor = Colors.blue,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
