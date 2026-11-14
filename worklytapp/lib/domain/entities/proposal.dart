enum ProposalStatus { pending, accepted, rejected }

class Proposal {
  Proposal({
    required this.id,
    required this.jobId,
    required this.freelancerId,
    required this.price,
    required this.coverLetter,
    this.durationDays,
    this.status = ProposalStatus.pending,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String id;
  final String jobId;
  final String freelancerId;
  final double price;
  final String coverLetter;
  final int? durationDays;
  final ProposalStatus status;
  final DateTime createdAt;

  Proposal copyWith({
    String? id,
    String? jobId,
    String? freelancerId,
    double? price,
    String? coverLetter,
    int? durationDays,
    ProposalStatus? status,
    DateTime? createdAt,
  }) {
    return Proposal(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      freelancerId: freelancerId ?? this.freelancerId,
      price: price ?? this.price,
      coverLetter: coverLetter ?? this.coverLetter,
      durationDays: durationDays ?? this.durationDays,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
