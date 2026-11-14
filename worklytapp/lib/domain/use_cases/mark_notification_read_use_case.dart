import 'package:worklyapp/domain/entities/notification.dart';
import 'package:worklyapp/domain/repositories/notification_repository.dart';

class MarkNotificationReadUseCase {
  const MarkNotificationReadUseCase(this.repository);
  final NotificationRepository repository;

  Future<void> execute({required String userId, String? notificationId}) async {
    if (userId.trim().isEmpty) throw ArgumentError('User ID is required.');
    if (notificationId == null) {
      await repository.markAllRead(userId);
      return;
    }
    final notifications = await repository.getNotifications(userId);
    AppNotification? match;
    for (final item in notifications) {
      if (item.id == notificationId) match = item;
    }
    if (match == null) {
      throw StateError('Notification not found for this user.');
    }
    if (!match.isRead) {
      await repository.updateNotification(match.copyWith(isRead: true));
    }
  }
}
