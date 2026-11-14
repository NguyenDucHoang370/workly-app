import 'package:workltapp/domain/entities/job.dart';
import 'package:workltapp/domain/entities/proposal.dart';
import 'package:workltapp/domain/repositories/job_repository.dart';

class CreateJobUseCase {
  CreateJobUseCase(this.repository);

  final JobRepository repository;

  Future<Job> execute({
    required String clientId,
    required String title,
    required String description,
    required String category,
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
    if (skills.isEmpty) {
      throw ArgumentError('At least one skill is required.');
    }
    if (budgetMin < 0 || budgetMax < 0) {
      throw ArgumentError('Budget values must be non-negative.');
    }
    if (budgetMin > budgetMax) {
      throw ArgumentError('Minimum budget cannot be greater than maximum budget.');
    }
    final minimumValidDeadline = DateTime.now().add(const Duration(days: 1));
    if (deadline.isBefore(minimumValidDeadline)) {
      throw ArgumentError('Deadline must be at least 1 day in the future.');
    }

    final job = Job(
      id: 'job_${DateTime.now().millisecondsSinceEpoch}',
      clientId: clientId,
      title: title.trim(),
      description: description.trim(),
      category: category.trim(),
      skills: skills.map((skill) => skill.trim()).where((skill) => skill.isNotEmpty).toList(),
      budgetMin: budgetMin,
      budgetMax: budgetMax,
      deadline: deadline,
      status: JobStatus.open,
    );

    return repository.createJob(job);
  }
}
