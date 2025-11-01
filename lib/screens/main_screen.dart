import 'package:flutter/material.dart';
import '../utils/app_sections.dart';
import 'scan_screen/scan_screen.dart';
import 'profile_screen.dart';
import 'programs_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<AppSection> _sections = const [
    AppSection(id: 'scan', icon: Icons.camera_alt, label: 'Scanner'),
    AppSection(id: 'profile', icon: Icons.person, label: 'Profil'),
    AppSection(id: 'programs', icon: Icons.calendar_today, label: 'Programmes'),
  ];

  final List<Widget> _screens = const [
    ScanScreen(),
    ProfileScreen(),
    ProgramsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green.shade600,
          unselectedItemColor: Colors.grey.shade500,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: [
            ..._sections.map((section) => BottomNavigationBarItem(
                  icon: Icon(section.icon),
                  label: section.label,
                )),
            //Ici pour rajouter des sections
          ],
        ),
      ),
    );
  }
}
