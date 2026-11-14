class Chat {
  Chat({
    required this.id,
    required List<String> participantIds,
    required this.jobId,
    this.lastMessage,
    required this.updatedAt,
  }) : participantIds = List.unmodifiable(participantIds);

  final String id;
  final List<String> participantIds;
  final String jobId;
  final String? lastMessage;
  final DateTime updatedAt;

  Chat copyWith({String? lastMessage, DateTime? updatedAt}) => Chat(
    id: id,
    participantIds: participantIds,
    jobId: jobId,
    lastMessage: lastMessage ?? this.lastMessage,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
