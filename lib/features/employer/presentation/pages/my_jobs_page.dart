import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // تمت إضافة استيراد GoRouter للتحكم بزر الرجوع

import '../../data/employer_provider.dart';
import 'job_applications_page.dart';

class MyJobsPage extends ConsumerWidget {
  const MyJobsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(myJobsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("وظائفي"),
        centerTitle: true,
        // إضافة زر الرجوع هنا
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/employer-home'); // العودة للوحة التحكم الخاصة بصاحب العمل
            }
          },
        ),
      ),
      body: jobsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => Center(
          child: Text(e.toString()),
        ),
        data: (jobs) {
          if (jobs.isEmpty) {
            return const Center(
              child: Text(
                "لا توجد وظائف منشورة",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JobApplicationsPage(
                          jobId: job['id'].toString(),
                          jobTitle: job['title'],
                        ),
                      ),
                    );
                  },

                  leading: const CircleAvatar(
                    child: Icon(Icons.work),
                  ),

                  title: Text(job['title'] ?? ''),

                  subtitle: Text(
                    "${job['company']} • ${job['city']}",
                  ),

                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == "delete") {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("حذف الوظيفة"),
                            content: const Text(
                              "هل تريد حذف هذه الوظيفة؟",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, false),
                                child: const Text("إلغاء"),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.pop(context, true),
                                child: const Text("حذف"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await ref
                              .read(employerProvider)
                              .deleteJob(job['id']);

                          ref.invalidate(myJobsProvider);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("تم حذف الوظيفة بنجاح"),
                              ),
                            );
                          }
                        }
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: "delete",
                        child: Text("حذف الوظيفة"),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}