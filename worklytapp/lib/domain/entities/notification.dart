enum NotificationType { proposal, message, contractStatus, submission, review }

class AppNotification {
  const AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.refId,
    required this.createdAt,
    this.isRead = false,
  });

  final String id;
  final String userId;
  final NotificationType type;
  final String refId;
  final bool isRead;
  final DateTime createdAt;

  AppNotification copyWith({bool? isRead}) => AppNotification(
    id: id,
    userId: userId,
    type: type,
    refId: refId,
    createdAt: createdAt,
    isRead: isRead ?? this.isRead,
  );
}
