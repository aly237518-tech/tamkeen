import 'package:flutter/material.dart';

import 'dashboard_page.dart';
import 'my_jobs_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class EmployerMainPage extends StatefulWidget {
  const EmployerMainPage({super.key});

  @override
  State<EmployerMainPage> createState() => _EmployerMainPageState();
}

class _EmployerMainPageState extends State<EmployerMainPage> {
  int currentIndex = 0;

  // تم حذف AddJobPage من القائمة
  final pages = const [
    DashboardPage(),
    MyJobsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: "لوحة التحكم",
          ),
          // تم حذف زر "إضافة وظيفة" من هنا أيضاً
          NavigationDestination(
            icon: Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work),
            label: "وظائفي",
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