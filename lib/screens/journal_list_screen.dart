import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../models/journal_model.dart';

class JournalListScreen extends StatefulWidget {
  const JournalListScreen({super.key});

  @override
  State<JournalListScreen> createState() => _JournalListScreenState();
}

class _JournalListScreenState extends State<JournalListScreen> {
  List<JournalModel> _journals = <JournalModel>[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJournals();
  }

  Future<void> _loadJournals() async {
    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final List<JournalModel> data =
          await DatabaseHelper.instance.getJournals();

      if (!mounted) {
        return;
      }

      setState(() {
        _journals = data;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error load journals: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteJournal(int id) async {
    try {
      await DatabaseHelper.instance.deleteJournal(id);
      _loadJournals();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Jurnal berhasil dihapus'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error deleting journal: $e');
    }
  }

  void _confirmDelete(JournalModel journal) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Hapus Jurnal'),
          content: Text('Yakin ingin menghapus "${journal.title}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('BATAL'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(context);
                if (journal.id != null) {
                  _deleteJournal(journal.id!);
                }
              },
              child: const Text('HAPUS', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  String _emoji(int level) {
    switch (level) {
      case 1:
        return '😊';
      case 2:
        return '🙂';
      case 3:
        return '😐';
      case 4:
        return '😔';
      case 5:
        return '😥';
      default:
        return '😐';
    }
  }

  Color _color(int level) {
    switch (level) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.lightGreen;
      case 3:
        return Colors.amber;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jurnal Saya'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadJournals();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _journals.isEmpty
              ? _emptyState()
              : _buildJournalList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/journal_form').then((_) {
            _loadJournalsIfNeeded();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _loadJournalsIfNeeded() {
    _loadJournals();
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.book_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'Belum ada jurnal kesehatan',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _journals.length,
      itemBuilder: (BuildContext context, int index) {
        final JournalModel journal = _journals[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  _color(journal.conditionLevel).withAlpha((0.2 * 255).toInt()),
              child: Text(
                _emoji(journal.conditionLevel),
                style: const TextStyle(fontSize: 20),
              ),
            ),
            title: Text(
              journal.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              journal.createdAt.length >= 10
                  ? journal.createdAt.substring(0, 10)
                  : journal.createdAt,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () {
                _confirmDelete(journal);
              },
            ),
            onTap: () {
              _showDetail(journal);
            },
          ),
        );
      },
    );
  }

  void _showDetail(JournalModel journal) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext _) {
        return JournalDetailSheet(journal: journal);
      },
    );
  }
}

class JournalDetailSheet extends StatelessWidget {
  final JournalModel journal;
  const JournalDetailSheet({super.key, required this.journal});

  String _emojiText(int level) {
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
        return '😐';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  journal.title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Chip(label: Text(_emojiText(journal.conditionLevel))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(journal.createdAt,
                  style: const TextStyle(color: Colors.grey)),
            ],
          ),
          if (journal.location.isNotEmpty) ...<Widget>[
            const SizedBox(height: 4),
            Row(
              children: <Widget>[
                const Icon(Icons.location_on, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(journal.location,
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
          const Divider(height: 30),
          const Text(
            'Catatan:',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                journal.description,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
