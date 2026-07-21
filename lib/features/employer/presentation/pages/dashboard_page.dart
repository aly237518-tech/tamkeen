import 'package:flutter/material.dart';
import '../../data/dashboard_service.dart';
import 'package:go_router/go_router.dart';
import 'employer_notifications_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardService dashboardService = DashboardService();

  bool loading = true;

  int jobs = 0;
  int applications = 0;
  int activeJobs = 0;
  int finishedJobs = 0;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    final stats = await dashboardService.getDashboardStats();

    setState(() {
      jobs = stats["jobs"] ?? 0;
      applications = stats["applications"] ?? 0;
      activeJobs = stats["activeJobs"] ?? 0;
      finishedJobs = stats["closedJobs"] ?? 0;
      loading = false;
    });
  }

  Widget statCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color.withOpacity(.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget quickAction(
      IconData icon,
      String title,
      Color color,
      VoidCallback? onTap,
      ) {
    return Card(
      elevation: 1,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(.15),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

return Scaffold(
      backgroundColor: const Color(0xffF9F5FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text("لوحة التحكم"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: Colors.black87),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EmployerNotificationsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadDashboard,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const Text(
              "مرحباً 👋",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "لوحة تحكم صاحب العمل",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

GridView.count(
  crossAxisCount: 2,
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  crossAxisSpacing: 15,
  mainAxisSpacing: 15,
  childAspectRatio: 2.2,
              children: [
                statCard(
                  icon: Icons.work_outline,
                  title: "الوظائف المنشورة",
                  value: jobs.toString(),
                  color: Colors.deepPurple,
                ),
                statCard(
                  icon: Icons.people_alt_outlined,
                  title: "المتقدمات",
                  value: applications.toString(),
                  color: Colors.orange,
                ),
                statCard(
                  icon: Icons.check_circle_outline,
                  title: "الوظائف النشطة",
                  value: activeJobs.toString(),
                  color: Colors.green,
                ),
                statCard(
                  icon: Icons.pause_circle_outline,
                  title: "الوظائف المنتهية",
                  value: finishedJobs.toString(),
                  color: Colors.red,
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "آخر الوظائف",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            FutureBuilder<List<Map<String, dynamic>>>(
              future: dashboardService.getLatestJobs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(25),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Center(
                      child: Text(
                        "لا توجد وظائف منشورة",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                final latestJobs = snapshot.data!;

                return Column(
                  children: latestJobs.map((job) {
                    final active =
                        job['is_active'] == true;

                    return Card(
                      margin:
                          const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: active
                              ? Colors.green.withOpacity(.15)
                              : Colors.red.withOpacity(.15),
                          child: Icon(
                            Icons.work,
                            color: active
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        title: Text(
                          job['title'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle:
                            Text(job['company'] ?? ''),

                        trailing: Chip(
                          backgroundColor: active
                              ? Colors.green.withOpacity(.15)
                              : Colors.red.withOpacity(.15),
                          label: Text(
                            active ? "نشطة" : "منتهية",
                            style: TextStyle(
                              color: active
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 30),

            const Text(
              "إجراءات سريعة",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),



quickAction(
  Icons.work_outline,
  "إدارة الوظائف",
  Colors.blue,
  () {
    context.push('/my-jobs');
  },
),



quickAction(
  Icons.person_outline,
  "الملف الشخصي",
  Colors.orange,
  () {
    context.push('/profile');
  },
),
],
),
),
);
}
}