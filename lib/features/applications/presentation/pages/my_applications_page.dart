import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/application_provider.dart';

class MyApplicationsPage extends ConsumerWidget {
  const MyApplicationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applications = ref.watch(myApplicationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("وظائفي"),
      ),
      body: applications.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => Center(
          child: Text(e.toString()),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text("لم تتقدمي لأي وظيفة بعد"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final app = items[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.work),
                  ),
                  title: Text(app.jobTitle),
                  subtitle: Text(
                    "${app.company} • ${app.city}",
                  ),
                  trailing: Chip(
                    label: Text(
                      _statusText(app.status),
                    ),
                    backgroundColor: app.status == "accepted" ? Colors.green[100] : null,
                  ),
                  // عرض تفاصيل المقابلة عند القبول فقط
// استبدل جزء الـ children في الكود السابق بهذا:
children: app.status == "accepted"
    ? [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              const Text("تفاصيل المقابلة:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("📅 الموعد: ${app.interviewDate ?? 'غير محدد'}"),
              Text("📍 العنوان: ${app.interviewAddress ?? 'غير محدد'}"), // تم التعديل
              Text("📞 رقم الشركة: ${app.companyPhone ?? 'غير محدد'}"), // تم التعديل
            ],
          ),
        )
      ]
    : [],
                ),
              );
            },
          );
        },
      ),
    );
  }

  static String _statusText(String status) {
    switch (status) {
      case "accepted":
        return "مقبول";

      case "rejected":
        return "مرفوض";

      default:
        return "قيد المراجعة";
    }
  }
}