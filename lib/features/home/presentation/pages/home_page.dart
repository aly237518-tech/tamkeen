import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../jobs/presentation/providers/job_provider.dart';
import '../widgets/home_header.dart';

import '../widgets/home_section_title.dart';
import '../widgets/quick_action_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(jobsProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF9F5FC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),

              const SizedBox(height: 25),

              

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: QuickActionCard(
                      icon: Icons.work_outline,
                      title: "الوظائف",
                      color: const Color(0xff6A1B9A),
                      onTap: () {
                        // تم التعديل هنا للانتقال إلى صفحة الوظائف مع push لضمان ظهور زر الرجوع
                        context.push('/jobs');
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: QuickActionCard(
                      icon: Icons.school_outlined,
                      title: "الدورات",
                      color: const Color(0xff9C27B0),
                      onTap: () {},
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              const HomeSectionTitle(
                title: "أحدث الوظائف",
              ),

              const SizedBox(height: 15),

              jobsAsync.when(
                data: (jobs) {
                  if (jobs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Center(
                        child: Text(
                          "لا توجد وظائف مطابقة",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: jobs.map((job) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              context.push('/job/${job.id}');
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 28,
                                        backgroundColor: Colors.grey.shade200,
                                        backgroundImage: null,
                                        child: const Icon(Icons.business),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              job.title,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              job.company,
                                              style: TextStyle(color: Colors.grey.shade700),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.favorite_border, color: Colors.red),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 18, color: Colors.deepPurple),
                                      const SizedBox(width: 4),
                                      Text(job.city),
                                      const SizedBox(width: 16),
                                      const Icon(Icons.payments, size: 18, color: Colors.green),
                                      const SizedBox(width: 4),
                                      Text(job.salary.isEmpty ? "غير محدد" : "${job.salary} د.ع"),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    children: [
                                      Chip(label: Text(job.employmentType)),
                                      Chip(label: Text(job.category)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Text(
                      error.toString(),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 35),

              const HomeSectionTitle(
                title: "الدورات المقترحة",
              ),

              const SizedBox(height: 15),

              _courseCard(
                title: "أساسيات ريادة الأعمال",
              ),

              const SizedBox(height: 12),

              _courseCard(
                title: "التسويق الرقمي",
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _courseCard({
    required String title,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          backgroundColor: Colors.purple.shade100,
          child: const Icon(
            Icons.school,
            color: Colors.deepPurple,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(
          Icons.play_circle_outline,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}