import 'package:worklyapp/domain/entities/review.dart';

abstract class ReviewRepository {
  Future<Review?> getReviewFromUserForContract(
    String contractId,
    String fromUserId,
  );
  Future<List<Review>> getReviewsForUser(String userId);
  Future<Review> createReview(Review review);
}
