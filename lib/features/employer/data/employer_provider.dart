import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// --- الموديل الخاص بإشعارات صاحب العمل ---
class EmployerNotificationModel {
  final String id;
  final String title;
  final String body;
  final String time;
  final bool isUnread;

  EmployerNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.isUnread,
  });

  factory EmployerNotificationModel.fromJson(Map<String, dynamic> json) {
    return EmployerNotificationModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      time: json['time'] ?? '',
      isUnread: json['is_unread'] ?? false,
    );
  }
}

// --- الـ Providers الخاصة بصاحب العمل والوظائف والإشعارات ---
final employerProvider = Provider((ref) {
  return EmployerService();
});

final myJobsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return ref.read(employerProvider).getMyJobs();
});

// Providers الخاصة بالإشعارات
final employerNotificationServiceProvider = Provider((ref) => EmployerNotificationService());

final employerNotificationsProvider = FutureProvider.autoDispose<List<EmployerNotificationModel>>((ref) async {
  final service = ref.watch(employerNotificationServiceProvider);
  return await service.getEmployerNotifications();
});


// --- كلاس الخدمة المدمج (وظائف + إشعارات) ---
class EmployerService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getMyJobs() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      debugPrint("❌ لا يوجد مستخدم مسجل دخول");
      return [];
    }

    debugPrint("✅ Current User ID: ${user.id}");

    final data = await supabase
        .from('jobs')
        .select()
        .eq('employer_id', user.id)
        .order('created_at', ascending: false);

    debugPrint("📌 Jobs Found: ${data.length}");
    debugPrint(data.toString());

    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> deleteJob(String jobId) async {
    await supabase
        .from('jobs')
        .delete()
        .eq('id', jobId);
  }
}

// --- كلاس خدمة إشعارات صاحب العمل المنفصل ---
class EmployerNotificationService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<EmployerNotificationModel>> getEmployerNotifications() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return [];

      final response = await supabase
          .from('employer_notifications')
          .select()
          .eq('employer_id', user.id) // جلب إشعارات صاحب العمل الحالي فقط
          .order('created_at', ascending: false);

      List data = response as List;
      return data.map((json) => EmployerNotificationModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("خطأ في جلب إشعارات صاحب العمل: $e");
      return [];
    }
  }

  Future<void> sendEmployerNotification({
    required String employerId,
    required String title,
    required String body,
    required String time,
  }) async {
    try {
      await supabase.from('employer_notifications').insert({
        'employer_id': employerId,
        'title': title,
        'body': body,
        'time': time,
        'is_unread': true,
      });
    } catch (e) {
      debugPrint('خطأ في إرسال إشعار صاحب العمل: $e');
    }
  }
}