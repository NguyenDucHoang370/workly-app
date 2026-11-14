enum FavoriteTargetType { job, freelancer }

class Favorite {
  const Favorite({
    required this.userId,
    required this.targetType,
    required this.targetId,
    required this.createdAt,
  });

  final String userId;
  final FavoriteTargetType targetType;
  final String targetId;
  final DateTime createdAt;
}
