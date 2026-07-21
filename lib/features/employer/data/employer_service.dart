import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class EmployerService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String> uploadCompanyLogo(File image) async {
    final fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
    await _supabase.storage.from("company-logos").upload(fileName, image);
    return _supabase.storage.from("company-logos").getPublicUrl(fileName);
  }

  Future<void> acceptApplicationWithDetails({
    required String id,
    required String date,
    required String address,
    required String phone,
  }) async {
    try {
      print("🚀 1. بدء عملية القبول للطلب ID: $id");

      // 1. تحديث حالة الطلب وإضافة تفاصيل المقابلة
      await _supabase.from('applications').update({
        'status': 'accepted',
        'interview_date': date,
        'interview_address': address,
        'company_phone': phone,
      }).eq('id', id);
      print("✅ 2. تم تحديث جدول applications بنجاح");

      // 2. جلب معرف المتقدم (user_id) لكي نرسل له الإشعار
      final applicationData = await _supabase
          .from('applications')
          .select('user_id')
          .eq('id', id)
          .single();

      final applicantUserId = applicationData['user_id'];
      print("🔎 3. الـ user_id المستخرج للمتقدم هو: $applicantUserId");

      // 3. إرسال الإشعار إلى جدول notifications الخاص بالمتقدم مع حقل الوقت (time)
      if (applicantUserId != null) {
        await _supabase.from('notifications').insert({
          'user_id': applicantUserId.toString(),
          'title': 'تم قبول طلبك بنجاح',
          'body': 'تهانينا! تم قبول طلبك، موعد المقابلة: $date',
          'is_unread': true,
          'time': DateTime.now().toIso8601String(), // تم إضافة حقل الوقت لتجاوز شرط قاعدة البيانات
        });
        print("🎉 4. تم إرسال الإشعار إلى جدول notifications بنجاح تام!");
      } else {
        print("⚠️ 4. المشكلة هنا: الـ user_id طلع فارغ (Null)!");
      }
    } catch (e) {
      print("❌ حدث خطأ برمجي أو في قاعدة البيانات: $e");
    }
  }

  Future<void> addJob({
    required String title,
    required String company,
    required String city,
    required String description,
    required String salary,
    required String employmentType,
    required String experience,
    required String category,
    String? imageUrl,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("يجب تسجيل الدخول أولاً");

    await _supabase.from('jobs').insert({
      'title': title,
      'company': company,
      'city': city,
      'description': description,
      'salary': salary,
      'employment_type': employmentType,
      'experience': experience,
      'category': category,
      'image_url': imageUrl,
      'employer_id': user.id,
      'created_by': user.id,
      'user_id': user.id,
      'is_active': true,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getMyJobs() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    try {
      final response = await _supabase
          .from('jobs')
          .select()
          .eq('employer_id', user.id)
          .order('created_at', ascending: false);

      return (response as List).map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      print("Error in getMyJobs: $e");
      return [];
    }
  }

  Future<void> deleteJob(String jobId) async {
    await _supabase.from('jobs').delete().eq('id', jobId);
  }

  Future<List<Map<String, dynamic>>> getApplications(String jobId) async {
    try {
      final response = await _supabase
          .from('applications')
          .select('''
            id, status, created_at, user_id,
            profiles(full_name, email, resume_url)
          ''')
          .eq('job_id', jobId)
          .order('created_at', ascending: false);

      return (response as List).map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      print("Error in getApplications: $e");
      return [];
    }
  }

  Future<void> acceptApplication(String applicationId) async {
    try {
      await _supabase.from('applications').update({'status': 'accepted'}).eq('id', applicationId);
    } catch (e) {
      print("Error in acceptApplication: $e");
    }
  }

  Future<void> rejectApplication(String applicationId) async {
    try {
      await _supabase.from('applications').update({'status': 'rejected'}).eq('id', applicationId);
    } catch (e) {
      print("Error in rejectApplication: $e");
    }
  }
}