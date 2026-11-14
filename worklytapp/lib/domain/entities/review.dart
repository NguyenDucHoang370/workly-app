class Review {
  const Review({
    required this.id,
    required this.contractId,
    required this.fromUserId,
    required this.toUserId,
    required this.rating,
    required this.createdAt,
    this.comment = '',
  });

  final String id;
  final String contractId;
  final String fromUserId;
  final String toUserId;
  final int rating;
  final DateTime createdAt;
  final String comment;
}
