import 'package:workltapp/domain/entities/job.dart';
import 'package:workltapp/domain/repositories/job_repository.dart';

class GetOpenJobsUseCase {
  GetOpenJobsUseCase(this.repository);

  final JobRepository repository;

  Future<List<Job>> execute() async {
    final jobs = await repository.getJobs();
    return jobs.where((job) => job.status == JobStatus.open).toList();
  }
}
