import 'package:worklyapp/domain/entities/notification.dart';
import 'package:worklyapp/domain/repositories/notification_repository.dart';

class GetNotificationsUseCase {
  const GetNotificationsUseCase(this.repository);
  final NotificationRepository repository;
  Future<List<AppNotification>> execute(
    String userId, {
    bool unreadOnly = false,
  }) {
    if (userId.trim().isEmpty) throw ArgumentError('User ID is required.');
    return repository.getNotifications(userId, unreadOnly: unreadOnly);
  }
}
