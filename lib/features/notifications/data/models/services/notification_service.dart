import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tamkeen/features/notifications/data/models/notification_model.dart';

class NotificationService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return [];

      // جلب الإشعارات الخاصة بالمستخدم الحالي فقط مرتبة حسب الوقت
      final response = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', user.id)
          .order('time', ascending: false);

      List data = response as List;
      return data.map((json) => NotificationModel.fromJson(json)).toList();
    } catch (e) {
      print("Error fetching notifications: $e");
      return [];
    }
  }
}