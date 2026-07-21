import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// إنشاء حساب جديد
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String city,
    required String role,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'city': city,
        'role': role,
      },
    );

    final user = response.user;

    if (user != null) {
      await _supabase.from('profiles').upsert({
        'id': user.id,
        'email': email,
        'full_name': fullName,
        'phone': phone,
        'city': city,
        'role': role,
      });
    }

    return response;
  }

  /// تسجيل الدخول
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// جلب نوع الحساب
  Future<String?> getUserRole() async {
    try {
      final user = _supabase.auth.currentUser;

      if (user == null) return null;

      final profile = await _supabase
          .from('profiles')
          .select('role')
          .eq('id', user.id)
          .maybeSingle();

      if (profile == null) {
        return null;
      }

      return profile['role']?.toString();
    } catch (e) {
      print("Error getUserRole: $e");
      return null;
    }
  }

  /// تسجيل الخروج
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  User? get currentUser => _supabase.auth.currentUser;
}