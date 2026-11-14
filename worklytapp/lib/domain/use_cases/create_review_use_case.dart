import 'package:worklyapp/domain/entities/contract.dart';
import 'package:worklyapp/domain/entities/review.dart';
import 'package:worklyapp/domain/repositories/contract_repository.dart';
import 'package:worklyapp/domain/repositories/review_repository.dart';

class CreateReviewUseCase {
  static int _idSequence = 0;
  const CreateReviewUseCase(this.contracts, this.reviews);
  final ContractRepository contracts;
  final ReviewRepository reviews;

  Future<Review> execute({
    required String contractId,
    required String fromUserId,
    required int rating,
    String comment = '',
  }) async {
    final contract = await contracts.getContractById(contractId);
    if (contract == null) throw StateError('Contract not found.');
    if (contract.status != ContractStatus.completed) {
      throw StateError('Reviews are only allowed after contract completion.');
    }
    final String toUserId;
    if (fromUserId == contract.clientId) {
      toUserId = contract.freelancerId;
    } else if (fromUserId == contract.freelancerId) {
      toUserId = contract.clientId;
    } else {
      throw StateError('Only contract participants can leave a review.');
    }
    if (rating < 1 || rating > 5) {
      throw ArgumentError('Rating must be between 1 and 5.');
    }
    if (await reviews.getReviewFromUserForContract(contractId, fromUserId) !=
        null) {
      throw StateError('A user can review a contract only once.');
    }
    final now = DateTime.now();
    return reviews.createReview(
      Review(
        id: 'review_${now.microsecondsSinceEpoch}_${_idSequence++}',
        contractId: contractId,
        fromUserId: fromUserId,
        toUserId: toUserId,
        rating: rating,
        comment: comment.trim(),
        createdAt: now,
      ),
    );
  }
}
