import 'package:worklyapp/domain/entities/job.dart';
import 'package:worklyapp/domain/repositories/job_repository.dart';

class CreateJobUseCase {
  static int _idSequence = 0;

  CreateJobUseCase(this.repository);

  final JobRepository repository;

  Future<Job> execute({
    required String clientId,
    required String title,
    required String description,
    required String category,
    String? categoryId,
    required List<String> skills,
    required double budgetMin,
    required double budgetMax,
    required DateTime deadline,
  }) async {
    if (clientId.trim().isEmpty) {
      throw ArgumentError('Client ID is required.');
    }
    if (title.trim().isEmpty) {
      throw ArgumentError('Job title cannot be empty.');
    }
    if (description.trim().isEmpty) {
      throw ArgumentError('Job description cannot be empty.');
    }
    if (category.trim().isEmpty) {
      throw ArgumentError('Category is required.');
    }
    final normalizedSkills = skills
        .map((skill) => skill.trim())
        .where((skill) => skill.isNotEmpty)
        .toList();
    if (normalizedSkills.isEmpty) {
      throw ArgumentError('At least one skill is required.');
    }
    if (!budgetMin.isFinite ||
        !budgetMax.isFinite ||
        budgetMin < 0 ||
        budgetMax < 0) {
      throw ArgumentError('Budget values must be non-negative.');
    }
    if (budgetMin > budgetMax) {
      throw ArgumentError(
        'Minimum budget cannot be greater than maximum budget.',
      );
    }
    final minimumValidDeadline = DateTime.now().add(const Duration(days: 1));
    if (deadline.isBefore(minimumValidDeadline)) {
      throw ArgumentError('Deadline must be at least 1 day in the future.');
    }

    final job = Job(
      id: 'job_${DateTime.now().microsecondsSinceEpoch}_${_idSequence++}',
      clientId: clientId,
      title: title.trim(),
      description: description.trim(),
      category: category.trim(),
      categoryId: categoryId?.trim().isNotEmpty == true
          ? categoryId!.trim()
          : category.trim(),
      skills: normalizedSkills,
      budgetMin: budgetMin,
      budgetMax: budgetMax,
      deadline: deadline,
      status: JobStatus.open,
    );

    return repository.createJob(job);
  }
}
