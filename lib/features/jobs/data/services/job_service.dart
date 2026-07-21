
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/job_model.dart';

class JobService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ==========================
  // جميع الوظائف
  // ==========================
  Future<List<JobModel>> getJobs() async {
    final data = await _supabase
        .from('jobs')
        .select()
        .order('created_at', ascending: false);

    print("========== JOBS ==========");
    print(data);

    return (data as List)
        .map((e) => JobModel.fromJson(e))
        .toList();
  }

  // ==========================
  // البحث
  // ==========================
  Future<List<JobModel>> searchJobs(String query) async {
    if (query.trim().isEmpty) return getJobs();

    try {
      final data = await _supabase
          .from('jobs')
          .select()
          .or('title.ilike.%$query%,company.ilike.%$query%,city.ilike.%$query%')
          .order('created_at', ascending: false);

      return (data as List)
          .map((e) => JobModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error in searchJobs: $e");
      return [];
    }
  }

  // ==========================
  // وظائف صاحب العمل (محدثة لتستخدم employer_id)
  // ==========================
  Future<List<JobModel>> getMyJobs() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    try {
      final data = await _supabase
          .from('jobs')
          .select()
          .eq('employer_id', user.id) // تم التعديل إلى employer_id بناءً على قاعدة البيانات
          .order('created_at', ascending: false);

      return (data as List)
          .map((e) => JobModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error in getMyJobs: $e");
      return [];
    }
  }

  // ==========================
  // التقديم على وظيفة + إرسال إشعار لصاحب العمل
  // ==========================
  Future<bool> applyForJob(String jobId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("يجب تسجيل الدخول أولاً");

    try {
      final existing = await _supabase
          .from('applications')
          .select()
          .eq('user_id', user.id)
          .eq('job_id', jobId);

      if ((existing as List).isNotEmpty) return false;

      // 1. حفظ التقديم في قاعدة البيانات
      await _supabase.from('applications').insert({
        'user_id': user.id,
        'job_id': jobId,
      });

      // 2. جلب معلومات الوظيفة باستخدام العمود الصحيح employer_id
      final jobData = await _supabase
          .from('jobs')
          .select('employer_id, title')
          .eq('id', jobId)
          .single();

      final employerId = jobData['employer_id'];
      final jobTitle = jobData['title'] ?? 'وظيفة';

      print("📌 Employer ID found: $employerId");

      // 3. إرسال إشعار تلقائي لصاحب العمل
      if (employerId != null) {
        await _supabase.from('employer_notifications').insert({
          'employer_id': employerId.toString(),
          'title': 'متقدم جديد على وظيفتك',
          'body': 'قدم شخص جديد على وظيفة: $jobTitle',
          'time': 'الآن',
          'is_unread': true,
        });
        print("✅ Notification sent successfully to employer!");
      }

      return true;
    } catch (e) {
      print("❌ Error in applyForJob: $e");
      return false;
    }
  }

  // ==========================
  // قبول الطلب + إرسال إشعار للمستخدم المتقدم
  // ==========================
  Future<void> acceptApplication({
    required String applicationId,
    required String date,
    required String address,
    required String phone,
  }) async {
    try {
      // 1. تحديث حالة الطلب إلى مقبول
      await _supabase.from('applications').update({
        'status': 'accepted',
        'interview_date': date,
        'interview_address': address,
        'company_phone': phone,
      }).eq('id', applicationId);

      // 2. جلب معلومات الطلب لمعرفة user_id الخاص بالمتقدم
      final applicationData = await _supabase
          .from('applications')
          .select('user_id')
          .eq('id', applicationId)
          .single();

      final applicantUserId = applicationData['user_id'];

      // 3. إرسال إشعار للمستخدم بأن طلبه قد قُبل
      if (applicantUserId != null) {
        await _supabase.from('notifications').insert({
          'user_id': applicantUserId.toString(),
          'title': 'تم قبول طلبك بنجاح',
          'body': 'تهانينا! تم قبول طلبك، موعد المقابلة: $date',
          'time': 'الآن',
          'is_unread': true,
        });
        print("✅ Acceptance notification sent to user!");
      }
    } catch (e) {
      print("Error in acceptApplication: $e");
    }
  }
}