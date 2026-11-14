import 'package:worklyapp/domain/entities/favorite.dart';
import 'package:worklyapp/domain/repositories/favorite_repository.dart';

class GetFavoritesUseCase {
  const GetFavoritesUseCase(this.repository);
  final FavoriteRepository repository;
  Future<List<Favorite>> execute(String userId) {
    if (userId.trim().isEmpty) throw ArgumentError('User ID is required.');
    return repository.getFavorites(userId);
  }
}
