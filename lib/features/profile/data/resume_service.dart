import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

class ResumeService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String?> uploadResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) return null;

    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception("يجب تسجيل الدخول أولاً");
    }

    final file = File(result.files.single.path!);

    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}";

    final storagePath = "${user.id}/$fileName";

    await _supabase.storage
        .from('resumes')
        .upload(
          storagePath,
          file,
          fileOptions: const FileOptions(
            upsert: true,
          ),
        );

    final url = _supabase.storage
        .from('resumes')
        .getPublicUrl(storagePath);

    await _supabase
        .from('profiles')
        .update({
          'resume_url': url,
        })
        .eq('id', user.id);

    return url;
  }

  Future<String?> getResumeUrl() async {
    final user = _supabase.auth.currentUser;

    if (user == null) return null;

    final data = await _supabase
        .from('profiles')
        .select('resume_url')
        .eq('id', user.id)
        .maybeSingle();

    return data?['resume_url'];
  }
}