import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../applications/data/application_service.dart';

class JobDetailsPage extends StatefulWidget {
  final String jobId;

  const JobDetailsPage({
    super.key,
    required this.jobId,
  });

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  final supabase = Supabase.instance.client;
  final applicationService = ApplicationService();

  Map<String, dynamic>? job;

  bool loading = true;
  bool applying = false;
  bool alreadyApplied = false;

  @override
  void initState() {
    super.initState();
    loadJob();
  }

  Future<void> loadJob() async {
    try {
      final result = await supabase
          .from('jobs')
          .select()
          .eq('id', widget.jobId)
          .single();

      final applied =
          await applicationService.hasApplied(widget.jobId);

      setState(() {
        job = result;
        alreadyApplied = applied;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().replaceFirst("Exception: ", ""),
            ),
          ),
        );
      }
    }
  }

  Future<void> apply() async {
    setState(() {
      applying = true;
    });

    try {
      // 1. تنفيذ التقديم على الوظيفة
      await applicationService.applyForJob(widget.jobId);

      // 2. إرسال إشعار إلى صاحب العمل (employer_id) الخاص بهذه الوظيفة
      final employerId = job?['employer_id'];
      final jobTitle = job?['title'] ?? 'وظيفة';

      if (employerId != null) {
        await supabase.from('employer_notifications').insert({
          'employer_id': employerId,
          'title': 'تقدم جديد على وظيفتك',
          'body': 'قام متقدّم بالتقديم على وظيفة: $jobTitle',
          'time': DateTime.now().toIso8601String(),
          'is_unread': true,
        });
      }

      if (!mounted) return;

      setState(() {
        alreadyApplied = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم إرسال طلبك بنجاح"),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst("Exception: ", ""),
          ),
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      applying = false;
    });
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

    if (job == null) {
      return const Scaffold(
        body: Center(
          child: Text("تعذر تحميل بيانات الوظيفة"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("تفاصيل الوظيفة"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((job!['image_url'] ?? '').toString().isNotEmpty)
              Center(
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage: NetworkImage(job!['image_url']),
                ),
              ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                job!['title'] ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.business),
              title: const Text("الشركة"),
              subtitle: Text(job!['company'] ?? ''),
            ),

            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text("المحافظة"),
              subtitle: Text(job!['city'] ?? ''),
            ),

            ListTile(
              leading: const Icon(Icons.payments),
              title: const Text("الراتب"),
              subtitle: Text(
                (job!['salary'] ?? '').toString().isEmpty
                    ? "غير محدد"
                    : "${job!['salary']} د.ع",
              ),
            ),

            ListTile(
              leading: const Icon(Icons.work),
              title: const Text("نوع الدوام"),
              subtitle: Text(job!['employment_type'] ?? 'غير محدد'),
            ),

            ListTile(
              leading: const Icon(Icons.school),
              title: const Text("الخبرة"),
              subtitle: Text(job!['experience'] ?? 'غير محدد'),
            ),

            ListTile(
              leading: const Icon(Icons.category),
              title: const Text("التصنيف"),
              subtitle: Text(job!['category'] ?? 'غير محدد'),
            ),

            const SizedBox(height: 20),

            const Text(
              "الوصف",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(),

            Text(
              job!['description'] ?? '',
              style: const TextStyle(
                fontSize: 16,
                height: 1.8,
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: (applying || alreadyApplied)
                    ? null
                    : apply,
                child: applying
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : Text(
                        alreadyApplied
                            ? "✓ تم التقديم"
                            : "التقديم على الوظيفة",
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}