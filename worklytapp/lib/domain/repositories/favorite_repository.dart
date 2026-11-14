import 'package:worklyapp/domain/entities/favorite.dart';

abstract class FavoriteRepository {
  Future<List<Favorite>> getFavorites(String userId);
  Future<bool> containsFavorite(
    String userId,
    FavoriteTargetType type,
    String targetId,
  );
  Future<Favorite> addFavorite(Favorite favorite);
  Future<void> removeFavorite(
    String userId,
    FavoriteTargetType type,
    String targetId,
  );
}
