import 'package:worklyapp/domain/entities/job.dart';
import 'package:worklyapp/domain/repositories/job_repository.dart';

class UpdateJobUseCase {
  const UpdateJobUseCase(this.repository);
  final JobRepository repository;

  Future<Job> execute({required String clientId, required Job job}) async {
    if (clientId.trim().isEmpty) throw ArgumentError('Client ID is required.');
    final saved = await repository.getJobById(job.id);
    if (saved == null) throw StateError('Job not found.');
    if (saved.clientId != clientId) {
      throw StateError('Only the job owner can update it.');
    }
    if (saved.status != JobStatus.open) {
      throw StateError('Only open jobs can be edited.');
    }
    if (job.title.trim().isEmpty || job.description.trim().isEmpty) {
      throw ArgumentError('Title and description are required.');
    }
    if (!job.budgetMin.isFinite ||
        !job.budgetMax.isFinite ||
        job.budgetMin < 0 ||
        job.budgetMin > job.budgetMax) {
      throw ArgumentError('A valid budget range is required.');
    }
    return repository.updateJob(
      job.copyWith(
        clientId: saved.clientId,
        title: job.title.trim(),
        description: job.description.trim(),
      ),
    );
  }
}
