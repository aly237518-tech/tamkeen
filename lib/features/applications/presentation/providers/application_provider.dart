import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/application_model.dart';
import '../../data/application_service.dart';

final applicationServiceProvider = Provider<ApplicationService>((ref) {
  return ApplicationService();
});

final myApplicationsProvider =
    FutureProvider<List<ApplicationModel>>((ref) async {
  return ref.read(applicationServiceProvider).getMyApplications();
});