import 'package:worklyapp/domain/entities/review.dart';
import 'package:worklyapp/domain/repositories/review_repository.dart';

class GetUserReviewsUseCase {
  const GetUserReviewsUseCase(this.repository);
  final ReviewRepository repository;
  Future<List<Review>> execute(String userId) {
    if (userId.trim().isEmpty) throw ArgumentError('User ID is required.');
    return repository.getReviewsForUser(userId);
  }
}
