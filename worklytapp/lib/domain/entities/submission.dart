enum SubmissionStatus { submitted, changesRequested, accepted }

class Submission {
  Submission({
    required this.id,
    required this.contractId,
    required List<String> files,
    required this.note,
    required this.status,
    required this.createdAt,
  }) : files = List.unmodifiable(files);

  final String id;
  final String contractId;
  final List<String> files;
  final String note;
  final SubmissionStatus status;
  final DateTime createdAt;

  Submission copyWith({
    List<String>? files,
    String? note,
    SubmissionStatus? status,
  }) => Submission(
    id: id,
    contractId: contractId,
    files: files ?? this.files,
    note: note ?? this.note,
    status: status ?? this.status,
    createdAt: createdAt,
  );
}
