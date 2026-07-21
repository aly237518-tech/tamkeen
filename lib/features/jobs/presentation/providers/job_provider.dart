import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/job_model.dart';
import '../../data/services/job_service.dart';

// الخدمة الأساسية
final jobServiceProvider = Provider<JobService>((ref) {
  return JobService();
});

// لجلب قائمة الوظائف
final jobsProvider = FutureProvider<List<JobModel>>((ref) async {
  return ref.read(jobServiceProvider).getJobs();
});

// Provider مخصص للعمليات (مثل قبول طلب التوظيف)
final jobOperationsProvider = Provider((ref) {
  final service = ref.read(jobServiceProvider);
  return JobOperations(service, ref);
});

class JobOperations {
  final JobService _service;
  final Ref _ref;

  JobOperations(this._service, this._ref);

  // دالة قبول الطلب
  Future<void> acceptApplication({
    required String applicationId,
    required String date,
    required String address,
    required String phone,
  }) async {
    // استدعاء الدالة من الـ Service
    await _service.acceptApplication(
      applicationId: applicationId,
      date: date,
      address: address,
      phone: phone,
    );
    
    // إعادة تحميل قائمة الوظائف أو الطلبات ليعكس التغيير في الواجهة
    _ref.invalidate(jobsProvider);
  }
}