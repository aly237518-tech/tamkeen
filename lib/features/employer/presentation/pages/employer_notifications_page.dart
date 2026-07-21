import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/employer_provider.dart';

class EmployerNotificationsPage extends ConsumerWidget {
  const EmployerNotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(employerNotificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إشعارات صاحب العمل'),
        centerTitle: true,
      ),
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return const Center(
              child: Text('لا توجد إشعارات حالياً', style: TextStyle(fontSize: 16, color: Colors.grey)),
            );
          }
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notif = notifications[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: notif.isUnread ? Colors.blue.shade100 : Colors.grey.shade200,
                    child: Icon(
                      Icons.notifications,
                      color: notif.isUnread ? Colors.blue : Colors.grey,
                    ),
                  ),
                  title: Text(
                    notif.title,
                    style: TextStyle(fontWeight: notif.isUnread ? FontWeight.bold : FontWeight.normal),
                  ),
                  subtitle: Text(notif.body),
                  trailing: Text(notif.time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('حدث خطأ: $err')),
      ),
    );
  }
}