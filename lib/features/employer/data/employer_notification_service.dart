import 'package:supabase_flutter/supabase_flutter.dart';
import 'employer_notification_model.dart';

class EmployerNotificationService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<EmployerNotificationModel>> getEmployerNotifications() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return [];

      // 1. جلب إشعارات صاحب العمل الحالي فقط، والترتيب حسب عمود time
      final response = await _supabase
          .from('employer_notifications')
          .select()
          .eq('user_id', user.id) // أو employer_id حسب اسم الحقل في جدول employer_notifications لديك
          .order('time', ascending: false);

      List data = response as List;
      return data.map((json) => EmployerNotificationModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching employer notifications: $e');
      return [];
    }
  }

  // إرسال إشعار لصاحب العمل مع ربطه بالـ user_id الخاص به
  Future<void> sendEmployerNotification({
    required String employerUserId, // معرف صاحب العمل المستهدف
    required String title,
    required String body,
  }) async {
    try {
      await _supabase.from('employer_notifications').insert({
        'user_id': employerUserId, // ربط الإشعار بصاحب العمل المحدد
        'title': title,
        'body': body,
        'time': DateTime.now().toIso8601String(), // الوقت الحالي لتجنب أخطاء قاعدة البيانات
        'is_unread': true,
      });
    } catch (e) {
      print('خطأ في إرسال إشعار صاحب العمل: $e');
    }
  }
}