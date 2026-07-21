import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// ===========================
  /// إحصائيات لوحة التحكم
  /// ===========================
Future<Map<String, int>> getDashboardStats() async {
  try {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      return {
        "jobs": 0,
        "applications": 0,
        "activeJobs": 0,
        "closedJobs": 0,
      };
    }

    // جميع وظائف صاحب العمل
    final jobs = await _supabase
        .from('jobs')
        .select('id,is_active')
        .eq('employer_id', user.id);

    final totalJobs = jobs.length;

    final activeJobs =
        jobs.where((e) => e['is_active'] == true).length;

    final closedJobs =
        jobs.where((e) => e['is_active'] == false).length;

    // استخراج جميع job_id الخاصة بصاحب العمل
    final jobIds =
        jobs.map((e) => e['id']).toList();

    int applications = 0;

    if (jobIds.isNotEmpty) {
      final apps = await _supabase
          .from('applications')
          .select('id')
          .inFilter('job_id', jobIds);

      applications = apps.length;
    }

    return {
      "jobs": totalJobs,
      "applications": applications,
      "activeJobs": activeJobs,
      "closedJobs": closedJobs,
    };
  } catch (e) {
    print(e);

    return {
      "jobs": 0,
      "applications": 0,
      "activeJobs": 0,
      "closedJobs": 0,
    };
  }
}
  /// ===========================
  /// آخر 5 وظائف منشورة
  /// ===========================
  Future<List<Map<String, dynamic>>> getLatestJobs() async {
    try {
      final user = _supabase.auth.currentUser;

      if (user == null) return [];

      final data = await _supabase
          .from('jobs')
          .select()
          .eq('employer_id', user.id)
          .order('created_at', ascending: false)
          .limit(5);

      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print("Latest Jobs Error:");
      print(e);
      return [];
    }
  }
}