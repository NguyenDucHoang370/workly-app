import 'package:worklyapp/domain/entities/job.dart';
import 'package:worklyapp/domain/repositories/job_repository.dart';

class GetJobUseCase {
  const GetJobUseCase(this.repository);
  final JobRepository repository;

  Future<Job> execute(String jobId) async {
    if (jobId.trim().isEmpty) throw ArgumentError('Job ID is required.');
    final job = await repository.getJobById(jobId);
    if (job == null) throw StateError('Job not found.');
    return job;
  }
}
