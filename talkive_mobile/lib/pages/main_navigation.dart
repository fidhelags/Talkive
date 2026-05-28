import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'available_slot_page.dart';
import 'profile_page.dart';
import 'package:flutter/services.dart';
import 'package:app_links/app_links.dart';
import '../services/session_service.dart';
import 'package:http/http.dart' as http;

class MainNavigationPage extends StatefulWidget {
  final int userId;
  final String userName;
  final String userEmail;

  const MainNavigationPage({
    super.key,
    required this.userId,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;
  String? _currentName;
  String? _currentEmail;
  late AppLinks _appLinks;

  static const _dark = Color(0xFF181818);
  static const _surface = Color(0xFF2A2A2A);
  static const _orange = Color(0xFFF97316);
  static const _gray = Color(0xFF94A3B8);

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  void _onProfileUpdated(String newName, String newEmail) {
    setState(() {
      _currentName = newName;
      _currentEmail = newEmail;
    });
  }

  void _initDeepLinks() {
    _appLinks = AppLinks();

    _appLinks.uriLinkStream.listen((uri) {
      if (uri.scheme == 'talkive' && uri.host == 'payment') {
        final status = uri.queryParameters['status'];

        if (!mounted) return;

        setState(() => _selectedIndex = 0);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              status == 'finish'
                  ? 'Payment successful!'
                  : status == 'pending'
                  ? 'Payment pending.'
                  : 'Payment failed.',
            ),
            backgroundColor: status == 'finish'
                ? Colors.orange
                : Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        );
      }
    });
  }

  Future<void> _onTabTapped(int index) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/users/${widget.userId}'),
      );

      if (response.statusCode != 200) {
        await SessionService.clearSession();

        if (!mounted) return;

        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);

        return;
      }
    } catch (e) {
      // Kalau server error / tidak bisa diakses,
      // tab tetap bisa dipindah
    }

    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final name = _currentName ?? widget.userName;
    final email = _currentEmail ?? widget.userEmail;

    final pages = [
      DashboardPage(userId: widget.userId, userName: name),
      AvailableSlotPage(userId: widget.userId),
      ProfilePage(
        userId: widget.userId,
        userName: name,
        userEmail: email,
        onProfileUpdated: _onProfileUpdated,
      ),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: _dark,
        body: pages[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: _surface,
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.05)),
            ),
          ),
          child: BottomNavigationBar(
            backgroundColor: _surface,
            currentIndex: _selectedIndex,
            onTap: _onTabTapped,
            selectedItemColor: _orange,
            unselectedItemColor: _gray,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 11),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_rounded),
                label: 'Available',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
