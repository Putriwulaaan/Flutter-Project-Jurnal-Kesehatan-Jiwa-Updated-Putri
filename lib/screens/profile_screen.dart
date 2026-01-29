import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controller untuk menangani input teks
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  // Fungsi untuk mengambil data profil dari database
  Future<void> _loadProfile() async {
    try {
      // PERBAIKAN: Menambahkan tipe data eksplisit Map<String, dynamic>?
      final Map<String, dynamic>? profile = await DatabaseHelper.instance
          .getProfile();

      if (!mounted) {
        return;
      }

      if (profile != null) {
        setState(() {
          _nameController.text = profile['name']?.toString() ?? '';
          _emailController.text = profile['email']?.toString() ?? '';
          _contactController.text =
              profile['emergency_contact']?.toString() ?? '';
        });
      }
    } catch (e) {
      debugPrint('Error load profile: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Fungsi untuk menyimpan perubahan profil
  Future<void> _saveProfile() async {
    // PERBAIKAN: Menambahkan tipe data String eksplisit
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String contact = _contactController.text.trim();

    if (name.isEmpty || contact.isEmpty || email.isEmpty) {
      _showSnack('Mohon isi semua data', Colors.orange);
      return;
    }

    try {
      await DatabaseHelper.instance.saveProfile(name, email, contact);

      if (!mounted) {
        return;
      }

      _showSnack('Profil berhasil diperbarui', Colors.green);

      // Memberi jeda sedikit agar user bisa melihat snackbar sebelum kembali
      // PERBAIKAN: Menambahkan tipe data Future<void>
      Future<void>.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    } catch (e) {
      _showSnack('Gagal menyimpan profil', Colors.red);
    }
  }

  void _showSnack(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Pengguna'), centerTitle: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                // PERBAIKAN: Menambahkan tipe data <Widget>
                children: <Widget>[
                  // Avatar Visual
                  const Center(
                    child: Stack(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // INPUT NAMA
                  _buildTextField(
                    controller: _nameController,
                    label: 'Nama Lengkap',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 15),

                  // INPUT EMAIL
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),

                  // INPUT KONTAK DARURAT
                  _buildTextField(
                    controller: _contactController,
                    label: 'Nomor Kontak Darurat',
                    icon: Icons.emergency_outlined,
                    keyboardType: TextInputType.phone,
                    helper: 'Nomor ini akan dihubungi jika kondisi darurat',
                  ),
                  const SizedBox(height: 30),

                  // TOMBOL SIMPAN
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.save),
                      label: const Text('SIMPAN PERUBAHAN'),
                      onPressed: _saveProfile,
                    ),
                  ),

                  const Divider(height: 40),

                  // TOMBOL LOGOUT
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        // PERBAIKAN: Menambahkan tipe data Route<dynamic>
                        (Route<dynamic> route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text(
                      'Keluar Akun',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Widget pembantu untuk merapikan kode TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? helper,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        helperText: helper,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
