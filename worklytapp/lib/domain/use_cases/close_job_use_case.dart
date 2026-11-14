import 'package:worklyapp/domain/entities/job.dart';
import 'package:worklyapp/domain/repositories/job_repository.dart';

class CloseJobUseCase {
  const CloseJobUseCase(this.repository);
  final JobRepository repository;

  Future<Job> execute({required String jobId, required String clientId}) async {
    final job = await repository.getJobById(jobId);
    if (job == null) throw StateError('Job not found.');
    if (job.clientId != clientId) {
      throw StateError('Only the job owner can close it.');
    }
    if (job.status != JobStatus.open) {
      throw StateError('Only open jobs can be closed.');
    }
    return repository.updateJob(job.copyWith(status: JobStatus.closed));
  }
}
