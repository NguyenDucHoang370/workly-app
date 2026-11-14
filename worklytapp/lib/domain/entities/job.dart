enum JobStatus { open, inProgress, submitted, completed, cancelled, closed }

class Job {
  Job({
    required this.id,
    required this.clientId,
    required this.title,
    required this.description,
    required this.category,
    String? categoryId,
    required this.skills,
    required this.budgetMin,
    required this.budgetMax,
    required this.deadline,
    this.status = JobStatus.open,
    DateTime? createdAt,
  }) : categoryId = categoryId ?? category,
       createdAt = createdAt ?? DateTime.now();

  final String id;
  final String clientId;
  final String title;
  final String description;
  final String category;
  final String categoryId;
  final List<String> skills;
  final double budgetMin;
  final double budgetMax;
  final DateTime deadline;
  final JobStatus status;
  final DateTime createdAt;

  Job copyWith({
    String? id,
    String? clientId,
    String? title,
    String? description,
    String? category,
    String? categoryId,
    List<String>? skills,
    double? budgetMin,
    double? budgetMax,
    DateTime? deadline,
    JobStatus? status,
    DateTime? createdAt,
  }) {
    return Job(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      skills: skills ?? this.skills,
      budgetMin: budgetMin ?? this.budgetMin,
      budgetMax: budgetMax ?? this.budgetMax,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
