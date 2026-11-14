import 'package:worklyapp/domain/entities/job.dart';

abstract class JobRepository {
  Future<List<Job>> getJobs({
    String? query,
    String? categoryId,
    List<String> skills = const [],
    double? minBudget,
    double? maxBudget,
    JobStatus? status,
    int limit = 20,
    String? cursorAfterId,
  });

  Future<Job> createJob(Job job);

  Future<Job?> getJobById(String jobId);

  Future<Job> updateJob(Job job);
}
