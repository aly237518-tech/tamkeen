import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/profile_provider.dart';

class EmployerProfilePage extends ConsumerWidget {
  const EmployerProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF9F5FC),
      appBar: AppBar(
        title: const Text("لوحة صاحب العمل"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: profileAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => Center(
          child: Text(e.toString()),
        ),
        data: (profile) {
          if (profile == null) {
            return const Center(
              child: Text("لا توجد بيانات"),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundColor: Color(0xff6A1B9A),
                  child: Icon(
                    Icons.business,
                    color: Colors.white,
                    size: 45,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  profile.fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                _item(
                  Icons.email_outlined,
                  "البريد الإلكتروني",
                  profile.email,
                ),

                _item(
                  Icons.location_on_outlined,
                  "المحافظة",
                  profile.city ?? "-",
                ),

                _item(
                  Icons.badge_outlined,
                  "نوع الحساب",
                  "صاحب عمل",
                ),

                const SizedBox(height: 20),

                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.add_business,
                      color: Color(0xff6A1B9A),
                    ),
                    title: const Text("إضافة وظيفة"),
                    subtitle: const Text("نشر فرصة عمل جديدة"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      context.push('/add-job');
                    },
                  ),
                ),

                const SizedBox(height: 12),

                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.work_outline,
                      color: Color(0xff6A1B9A),
                    ),
                    title: const Text("وظائفي"),
                    subtitle: const Text("عرض الوظائف وإدارة المتقدمات"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      context.push('/my-jobs');
                    },
                  ),
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () async {
                      await ref
                          .read(profileServiceProvider)
                          .signOut();

                      if (context.mounted) {
                        context.go('/login');
                      }
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "تسجيل الخروج",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static Widget _item(
    IconData icon,
    String title,
    String value,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xff6A1B9A),
        ),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}