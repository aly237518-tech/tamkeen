import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile_model.dart';

class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<ProfileModel?> getProfile() async {
    try {
      final user = _supabase.auth.currentUser;

      if (user == null) return null;

      // استخدام maybeSingle بدلاً من single لتجنب الخطأ في حال عدم وجود سجل
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      // إذا لم يتم العثور على بيانات، نرجع null بدلاً من محاولة التحويل
      if (data == null) return null;

      return ProfileModel.fromJson(data);
    } catch (e) {
      // معالجة أي خطأ غير متوقع ومنع انهيار التطبيق
      debugPrint("❌ Error fetching profile: $e");
      return null;
    }
  }

Future<void> signOut() async {
  try {
    // 1. تسجيل الخروج الرسمي من Supabase
    await Supabase.instance.client.auth.signOut(scope: SignOutScope.global);
  } catch (e) {
    debugPrint("خطأ أثناء تسجيل الخروج: $e");
    
    // 2. إذا فشلت العملية، نقوم بمسح التخزين المحلي يدوياً
    // هذه الطريقة آمنة ولا تسبب خطأ النوع (Null vs String)
    await Supabase.instance.client.auth.recoverSession(''); 
  }
}
}