import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/profile_model.dart';
import '../../data/profile_service.dart';

final profileServiceProvider = Provider((ref) {
  return ProfileService();
});

final profileProvider = FutureProvider<ProfileModel?>((ref) async {
  return ref.read(profileServiceProvider).getProfile();
});