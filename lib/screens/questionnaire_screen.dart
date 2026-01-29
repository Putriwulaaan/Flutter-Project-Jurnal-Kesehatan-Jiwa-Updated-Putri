import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<bool?> _answers = List<bool?>.filled(20, null);

  final List<String> _questions = <String>[
    'Apakah Anda sering merasa sakit kepala?',
    'Apakah Anda tidak nafsu makan?',
    'Apakah Anda sulit tidur nyenyak?',
    'Apakah Anda mudah merasa takut?',
    'Apakah Anda merasa tegang, cemas, atau khawatir?',
    'Apakah tangan Anda gemetar?',
    'Apakah pencernaan Anda terganggu?',
    'Apakah Anda sulit berpikir jernih?',
    'Apakah Anda merasa tidak bahagia?',
    'Apakah Anda lebih sering menangis?',
    'Apakah Anda sulit menikmati kegiatan sehari-hari?',
    'Apakah Anda sulit mengambil keputusan?',
    'Apakah pekerjaan sehari-hari Anda terganggu?',
    'Apakah Anda merasa tidak mampu melakukan hal yang bermanfaat?',
    'Apakah Anda kehilangan minat pada berbagai hal?',
    'Apakah Anda merasa diri Anda tidak berharga?',
    'Apakah Anda mempunyai pikiran untuk mengakhiri hidup?',
    'Apakah Anda merasa lelah sepanjang waktu?',
    'Apakah Anda merasa tidak enak di perut?',
    'Apakah Anda mudah lelah?',
  ];

  void _submitAnswer(bool value) {
    setState(() {
      _answers[_currentPage] = value;
    });

    if (_currentPage < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _processResults();
    }
  }

  Future<void> _processResults() async {
    final int score = _answers.where((bool? element) => element == true).length;

    final bool isEmergency = _answers[16] == true;

    if (isEmergency) {
      await NotificationService().showEmergencyNotification(
        'PERINGATAN KRITIS',
        'Kami mendeteksi kondisi berisiko. Silakan hubungi kontak darurat Anda.',
      );
    }

    if (!mounted) {
      return;
    }
    _showResultDialog(score, isEmergency);
  }

  void _showResultDialog(int score, bool isEmergency) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text(isEmergency ? '⚠️ PERINGATAN' : 'Hasil Kuesioner'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Skor Anda: $score / 20',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            Text(
              isEmergency
                  ? 'Kami mendeteksi pikiran yang sangat serius. Mohon segera hubungi orang terpercaya atau tenaga medis.'
                  : score >= 6
                  ? 'Terdapat indikasi stres atau kecemasan. Jangan ragu untuk bercerita.'
                  : 'Kondisi mental Anda saat ini relatif stabil.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text(isEmergency ? 'KONTAK DARURAT' : 'KEMBALI KE HOME'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(
                context,
                isEmergency ? '/emergency_contact' : '/home',
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pertanyaan ${_currentPage + 1}/20'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          LinearProgressIndicator(
            value: (_currentPage + 1) / _questions.length,
            color: Colors.blue.shade800,
            backgroundColor: Colors.blue.shade100,
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (int page) {
                setState(() => _currentPage = page);
              },
              itemCount: _questions.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _questions[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 60),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(120, 50),
                            ),
                            onPressed: () => _submitAnswer(true),
                            child: const Text(
                              'YA',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade400,
                              minimumSize: const Size(120, 50),
                            ),
                            onPressed: () => _submitAnswer(false),
                            child: const Text(
                              'TIDAK',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
