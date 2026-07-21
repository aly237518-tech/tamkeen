import 'package:flutter/material.dart';

class ApplicationCard extends StatelessWidget {
  final Map<String, dynamic> application;

  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onOpenResume;

  const ApplicationCard({
    super.key,
    required this.application,
    required this.onAccept,
    required this.onReject,
    required this.onOpenResume,
  });

  @override
  Widget build(BuildContext context) {
    final profile = application['profiles'];

    final String name = profile?['full_name'] ?? "بدون اسم";
    final String email = profile?['email'] ?? "";
    final String status = application['status'] ?? "pending";

    Color statusColor = Colors.orange;

    if (status == "accepted") {
      statusColor = Colors.green;
    } else if (status == "rejected") {
      statusColor = Colors.red;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(name),
              subtitle: Text(email),
            ),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: Chip(
                backgroundColor: statusColor.withOpacity(.15),
                label: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onOpenResume,
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text("عرض السيرة الذاتية"),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onAccept,
                    icon: const Icon(Icons.check),
                    label: const Text("قبول"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onReject,
                    icon: const Icon(Icons.close),
                    label: const Text("رفض"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}