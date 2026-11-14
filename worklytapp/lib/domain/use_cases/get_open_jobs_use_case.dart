import 'package:worklyapp/domain/entities/job.dart';
import 'package:worklyapp/domain/repositories/job_repository.dart';

class GetOpenJobsUseCase {
  GetOpenJobsUseCase(this.repository);

  final JobRepository repository;

  Future<List<Job>> execute() async {
    return repository.getJobs(status: JobStatus.open);
  }
}
