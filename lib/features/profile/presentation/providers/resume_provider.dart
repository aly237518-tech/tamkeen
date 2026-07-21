import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/resume_service.dart';

final resumeServiceProvider = Provider<ResumeService>((ref) {
  return ResumeService();
});

final resumeUrlProvider = FutureProvider<String?>((ref) async {
  return ref.read(resumeServiceProvider).getResumeUrl();
});