import 'package:flutter/material.dart';

// SERVICES
import 'services/notification_service.dart';

// SCREENS
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/journal_list_screen.dart';
import 'screens/journal_form_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/emergency_screen.dart';
import 'screens/emergency_contact_screen.dart';
import 'screens/questionnaire_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NotificationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Jurnal Kesehatan Jiwa',
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        // Splash & Auth
        '/': (BuildContext context) => const SplashScreen(),
        '/login': (BuildContext context) => const LoginScreen(),

        // Home
        '/home': (BuildContext context) => const HomeScreen(),

        // Jurnal
        '/journal_list': (BuildContext context) => const JournalListScreen(),
        '/journal_form': (BuildContext context) => const JournalFormScreen(),

        // Statistik & Pengaturan
        '/stats': (BuildContext context) => const StatisticsScreen(),
        '/settings': (BuildContext context) => const SettingsScreen(),
        '/profile': (BuildContext context) => const ProfileScreen(),

        // Emergency
        '/emergency': (BuildContext context) => const EmergencyScreen(),
        '/emergency_contact': (BuildContext context) =>
            const EmergencyContactScreen(),

        // Kuesioner
        '/questionnaire_screen': (BuildContext context) =>
            const QuestionnaireScreen(),
      },
    );
  }
}
