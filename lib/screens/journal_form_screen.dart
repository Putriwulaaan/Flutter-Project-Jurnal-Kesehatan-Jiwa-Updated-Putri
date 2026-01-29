import 'package:flutter/material.dart';
import '../models/journal_model.dart';
import '../services/database_helper.dart';

class JournalFormScreen extends StatefulWidget {
  final JournalModel? journal;

  const JournalFormScreen({super.key, this.journal});

  @override
  State<JournalFormScreen> createState() => _JournalFormScreenState();
}

class _JournalFormScreenState extends State<JournalFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _locationController;

  int _conditionLevel = 3;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.journal != null;
    _titleController = TextEditingController(text: widget.journal?.title ?? '');
    _descController = TextEditingController(
      text: widget.journal?.description ?? '',
    );
    _locationController = TextEditingController(
      text: widget.journal?.location ?? '',
    );
    _conditionLevel = widget.journal?.conditionLevel ?? 3;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _saveJournal() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final JournalModel newJournal = JournalModel(
      id: widget.journal?.id,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      conditionLevel: _conditionLevel,
      location: _locationController.text.trim(),
      createdAt: widget.journal?.createdAt ?? DateTime.now().toIso8601String(),
    );

    try {
      if (_isEdit) {
        await DatabaseHelper.instance.updateJournal(newJournal);
      } else {
        await DatabaseHelper.instance.insertJournal(newJournal);
      }

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEdit ? 'Jurnal diperbarui' : 'Jurnal disimpan'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint('Error saving: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Jurnal' : 'Tulis Jurnal Baru'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Bagaimana perasaanmu?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              _buildConditionSelector(),
              const SizedBox(height: 30),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Catatan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (String? v) => (v == null || v.isEmpty)
                    ? 'Judul tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Lokasi (Opsional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Ceritakan perasaanmu...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (String? v) =>
                    (v == null || v.isEmpty) ? 'Ceritakan sedikit dong' : null,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _saveJournal,
                  icon: const Icon(Icons.check_circle),
                  label: Text(_isEdit ? 'UPDATE JURNAL' : 'SIMPAN JURNAL'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConditionSelector() {
    final List<Map<String, dynamic>> conditions = <Map<String, dynamic>>[
      <String, dynamic>{'level': 1, 'emoji': '😊', 'color': Colors.green},
      <String, dynamic>{'level': 2, 'emoji': '🙂', 'color': Colors.lightGreen},
      <String, dynamic>{'level': 3, 'emoji': '😐', 'color': Colors.amber},
      <String, dynamic>{'level': 4, 'emoji': '😔', 'color': Colors.orange},
      <String, dynamic>{'level': 5, 'emoji': '😥', 'color': Colors.red},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: conditions.map((Map<String, dynamic> item) {
        final bool isSelected = _conditionLevel == item['level'];
        final Color itemColor = item['color'] as Color;
        return GestureDetector(
          onTap: () => setState(() => _conditionLevel = item['level'] as int),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              // Menggunakan withAlpha untuk menghindari deprecated withOpacity pada versi Flutter terbaru
              color: isSelected ? itemColor.withAlpha(51) : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? itemColor : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: Text(
              item['emoji'] as String,
              style: const TextStyle(fontSize: 30),
            ),
          ),
        );
      }).toList(),
    );
  }
}
