enum ContractStatus {
  inProgress,
  submitted,
  changesRequested,
  completed,
  cancelled,
}

class Contract {
  const Contract({
    required this.id,
    required this.jobId,
    required this.proposalId,
    required this.clientId,
    required this.freelancerId,
    required this.agreedPrice,
    required this.status,
    required this.startedAt,
    this.completedAt,
  });

  final String id;
  final String jobId;
  final String proposalId;
  final String clientId;
  final String freelancerId;
  final double agreedPrice;
  final ContractStatus status;
  final DateTime startedAt;
  final DateTime? completedAt;

  Contract copyWith({
    ContractStatus? status,
    DateTime? completedAt,
    bool clearCompletedAt = false,
  }) => Contract(
    id: id,
    jobId: jobId,
    proposalId: proposalId,
    clientId: clientId,
    freelancerId: freelancerId,
    agreedPrice: agreedPrice,
    status: status ?? this.status,
    startedAt: startedAt,
    completedAt: clearCompletedAt ? null : completedAt ?? this.completedAt,
  );
}
