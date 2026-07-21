import 'package:flutter/material.dart';

import '../../../home/presentation/pages/home_page.dart';

import '../../../courses/presentation/pages/courses_page.dart';
import '../../../success/presentation/pages/success_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../applications/presentation/pages/my_applications_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

late final List<Widget> pages = [
  const HomePage(),
  const MyApplicationsPage(),
  const CoursesPage(),
  const SuccessPage(),
  const ProfilePage(),
];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
body: pages[currentIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        height: 72,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "الرئيسية",
          ),
          NavigationDestination(
            icon: Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work),
            label: "الوظائف",
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: "الدورات",
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events),
            label: "النجاحات",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: "حسابي",
          ),
        ],
      ),
    );
  }
}