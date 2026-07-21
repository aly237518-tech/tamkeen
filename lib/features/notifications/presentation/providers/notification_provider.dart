import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tamkeen/features/notifications/data/models/services/notification_service.dart';
import 'package:tamkeen/features/notifications/data/models/notification_model.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final notificationsProvider = FutureProvider.autoDispose<List<NotificationModel>>((ref) async {
  final service = ref.watch(notificationServiceProvider);
  return await service.getNotifications();
});