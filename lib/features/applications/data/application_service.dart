import 'package:supabase_flutter/supabase_flutter.dart';

import 'application_model.dart';

class ApplicationService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// التقديم على وظيفة
  Future<void> applyForJob(String jobId) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception("يجب تسجيل الدخول أولاً");
    }

    // التحقق من وجود السيرة الذاتية
    final profile = await _supabase
        .from('profiles')
        .select('resume_url')
        .eq('id', user.id)
        .maybeSingle();

    final resumeUrl = profile?['resume_url'];

    if (resumeUrl == null ||
        resumeUrl.toString().trim().isEmpty) {
      throw Exception("يرجى رفع السيرة الذاتية أولاً");
    }

    // منع التقديم مرتين
    final exists = await _supabase
        .from('applications')
        .select('id')
        .eq('user_id', user.id)
        .eq('job_id', jobId)
        .maybeSingle();

    if (exists != null) {
      throw Exception("لقد تقدمتِ لهذه الوظيفة مسبقاً");
    }

    // إنشاء الطلب
    await _supabase.from('applications').insert({
      'user_id': user.id,
      'job_id': jobId,
      'status': 'pending',
    });
  }

  /// التحقق هل المستخدم قدم على هذه الوظيفة سابقاً
  Future<bool> hasApplied(String jobId) async {
    final user = _supabase.auth.currentUser;

    if (user == null) return false;

    final result = await _supabase
        .from('applications')
        .select('id')
        .eq('user_id', user.id)
        .eq('job_id', jobId)
        .maybeSingle();

    return result != null;
  }

  /// جلب طلبات المستخدم
  Future<List<ApplicationModel>> getMyApplications() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      return [];
    }

    // تمت إضافة الحقول الجديدة هنا ليتم جلبها من Supabase
    final data = await _supabase
        .from('applications')
        .select('''
          id,
          status,
          created_at,
          interview_date,
          interview_address,
          company_phone,
          jobs(
            title,
            company,
            city
          )
        ''')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return (data as List)
        .map((e) => ApplicationModel.fromJson(e))
        .toList();
  }
}