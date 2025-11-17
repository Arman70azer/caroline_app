import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../utils/app_sections.dart';
import '../widgets/compact_header.dart';
import 'scan_screen/scan_screen.dart';
import 'profile_screen/profile_screen.dart';
import 'programs_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  final List<AppSection> _sections = const [
    AppSection(id: 'scan', icon: Icons.camera_alt, label: 'Scanner'),
    AppSection(id: 'profile', icon: Icons.person, label: 'Profil'),
    AppSection(id: 'programs', icon: Icons.calendar_today, label: 'Programmes'),
  ];

  final List<Widget> _screens = const [
    ModernScanScreen(),
    ProfileScreen(),
    ProgramsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onNavBarTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const CompactHeader(),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                physics: const BouncingScrollPhysics(),
                children: _screens,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onNavBarTap,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryGreen,
          unselectedItemColor: AppColors.textSecondary,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          backgroundColor: Colors.transparent,
          items: _sections
              .map((section) => BottomNavigationBarItem(
                    icon: Icon(section.icon),
                    label: section.label,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
