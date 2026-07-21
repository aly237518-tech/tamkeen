import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/employer_service.dart';
import '../widgets/application_card.dart';

class JobApplicationsPage extends StatefulWidget {
  final String jobId;
  final String jobTitle;

  const JobApplicationsPage({
    super.key,
    required this.jobId,
    required this.jobTitle,
  });

  @override
  State<JobApplicationsPage> createState() =>
      _JobApplicationsPageState();
}

class _JobApplicationsPageState
    extends State<JobApplicationsPage> {
  final EmployerService _service = EmployerService();

  bool loading = true;

  List<Map<String, dynamic>> applications = [];

  @override
  void initState() {
    super.initState();
    loadApplications();
  }

  Future<void> loadApplications() async {
    setState(() {
      loading = true;
    });

    applications =
        await _service.getApplications(widget.jobId);

    setState(() {
      loading = false;
    });
  }

  Future<void> openResume(String? url) async {
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("لا توجد سيرة ذاتية"),
        ),
      );
      return;
    }

    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Future<void> showAcceptanceDialog(String id) async {
    final TextEditingController dateController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("قبول المتقدمة"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: dateController, decoration: const InputDecoration(labelText: "تاريخ المقابلة")),
            TextField(controller: addressController, decoration: const InputDecoration(labelText: "مكان المقابلة")),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: "رقم هاتف الشركة")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
          ElevatedButton(
            onPressed: () async {
              // تم تعديل المعرف ليطابق الخدمة id: id
              await _service.acceptApplicationWithDetails(
                id: id,
                date: dateController.text,
                address: addressController.text,
                phone: phoneController.text,
              );
              
              await loadApplications();
              if (mounted) Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("تم قبول المتقدمة بنجاح وإرسال الإشعار")),
              );
            },
            child: const Text("إرسال القبول"),
          ),
        ],
      ),
    );
  }

  Future<void> reject(String id) async {
    await _service.rejectApplication(id);

    await loadApplications();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("تم رفض المتقدمة"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.jobTitle),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : applications.isEmpty
              ? const Center(
                  child: Text(
                    "لا يوجد متقدمون لهذه الوظيفة",
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: applications.length,
                  itemBuilder: (context, index) {
                    final app = applications[index];

                    final profile =
                        app['profiles'] ?? {};

                    return ApplicationCard(
                      application: app,
                      onAccept: () =>
                          showAcceptanceDialog(app['id'].toString()),
                      onReject: () =>
                          reject(app['id'].toString()),
                      onOpenResume: () => openResume(
                        profile['resume_url'],
                      ),
                    );
                  },
                ),
    );
  }
}