import 'package:flutter/material.dart';
import '../models/journal_model.dart';

class DetailScreen extends StatelessWidget {
  final JournalModel journal;

  const DetailScreen({super.key, required this.journal});

  // Helper untuk menampilkan status berdasarkan conditionLevel
  String _getConditionText(int level) {
    switch (level) {
      case 1:
        return '😊 Baik';
      case 2:
        return '🙂 Cukup';
      case 3:
        return '😐 Biasa';
      case 4:
        return '😔 Buruk';
      case 5:
        return '😥 Sangat Buruk';
      default:
        return '😐 Netral';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Jurnal'),
        centerTitle: true,
        // PERBAIKAN: Menambahkan tipe data <Widget>
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Jurnal',
            onPressed: () {
              // Menuju halaman form dengan membawa data journal untuk di-edit
              Navigator.pushNamed(context, '/journal_form', arguments: journal);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // PERBAIKAN: Menambahkan tipe data <Widget>
          children: <Widget>[
            // ===============================
            // TANGGAL & KONDISI
            // ===============================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.calendar_month,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      journal.createdAt.substring(0, 10),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Chip(
                  backgroundColor: Colors.blue.shade50,
                  side: BorderSide(color: Colors.blue.shade100),
                  label: Text(
                    _getConditionText(journal.conditionLevel),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ===============================
            // JUDUL
            // ===============================
            Text(
              journal.title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),

            const Divider(height: 40, thickness: 1),

            // ===============================
            // DESKRIPSI / ISI JURNAL
            // ===============================
            // PERBAIKAN: Menggunakan single quotes
            const Text(
              'Catatan Hari Ini:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              journal.description,
              style: const TextStyle(
                fontSize: 18,
                height: 1.6,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 40),

            // ===============================
            // LOKASI
            // ===============================
            if (journal.location.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.location_on, color: Colors.redAccent),
                  ),
                  // PERBAIKAN: Menggunakan single quotes
                  title: const Text(
                    'Lokasi',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  subtitle: Text(
                    journal.location,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 30),

            // ===============================
            // TOMBOL KEMBALI
            // ===============================
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.arrow_back),
                label: const Text(
                  'KEMBALI KE DAFTAR',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
