import 'package:worklyapp/domain/entities/notification.dart';

abstract class NotificationRepository {
  Future<List<AppNotification>> getNotifications(
    String userId, {
    bool unreadOnly = false,
  });
  Future<AppNotification> updateNotification(AppNotification notification);
  Future<void> markAllRead(String userId);
}
