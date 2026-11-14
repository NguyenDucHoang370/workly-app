import 'package:workltapp/domain/entities/job.dart';

class Proposal {
  Proposal({
    required this.id,
    required this.jobId,
    required this.freelancerId,
    required this.price,
    required this.coverLetter,
    this.status = ProposalStatus.pending,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String id;
  final String jobId;
  final String freelancerId;
  final double price;
  final String coverLetter;
  final ProposalStatus status;
  final DateTime createdAt;

  Proposal copyWith({
    String? id,
    String? jobId,
    String? freelancerId,
    double? price,
    String? coverLetter,
    ProposalStatus? status,
    DateTime? createdAt,
  }) {
    return Proposal(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      freelancerId: freelancerId ?? this.freelancerId,
      price: price ?? this.price,
      coverLetter: coverLetter ?? this.coverLetter,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
