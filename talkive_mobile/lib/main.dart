import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/landing_page.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/main_navigation.dart';
import 'pages/splash_screen.dart';
import 'services/session_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.init();

  runApp(const TalkiveApp());
}

class TalkiveApp extends StatelessWidget {
  const TalkiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Talkive',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF181818),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF97316),
          surface: Color(0xFF2A2A2A),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/landing': (context) => const LandingPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboard') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (_) => MainNavigationPage(
              userId: args?['userId'] ?? 0,
              userName: args?['userName'] ?? 'Guest',
              userEmail: args?['userEmail'] ?? '',
            ),
          );
        }
        return null;
      },
    );
  }
}

class _StartupPage extends StatefulWidget {
  const _StartupPage();

  @override
  State<_StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<_StartupPage> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final session = await SessionService.getSession();
    if (!mounted) return;

    if (session != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainNavigationPage(
            userId: session['userId'],
            userName: session['userName'],
            userEmail: session['userEmail'],
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LandingPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF181818),
      body: Center(child: CircularProgressIndicator(color: Color(0xFFF97316))),
    );
  }
}
