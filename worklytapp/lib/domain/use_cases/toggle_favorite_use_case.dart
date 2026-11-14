import 'package:worklyapp/domain/entities/favorite.dart';
import 'package:worklyapp/domain/repositories/favorite_repository.dart';

class ToggleFavoriteUseCase {
  const ToggleFavoriteUseCase(this.repository);
  final FavoriteRepository repository;

  Future<bool> execute({
    required String userId,
    required FavoriteTargetType targetType,
    required String targetId,
  }) async {
    if (userId.trim().isEmpty || targetId.trim().isEmpty) {
      throw ArgumentError('User ID and target ID are required.');
    }
    if (await repository.containsFavorite(userId, targetType, targetId)) {
      await repository.removeFavorite(userId, targetType, targetId);
      return false;
    }
    await repository.addFavorite(
      Favorite(
        userId: userId,
        targetType: targetType,
        targetId: targetId,
        createdAt: DateTime.now(),
      ),
    );
    return true;
  }
}
