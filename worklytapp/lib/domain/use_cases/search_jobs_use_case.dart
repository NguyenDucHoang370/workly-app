import 'package:worklyapp/domain/entities/job.dart';
import 'package:worklyapp/domain/repositories/job_repository.dart';

class SearchJobsUseCase {
  const SearchJobsUseCase(this.repository);
  final JobRepository repository;

  Future<List<Job>> execute({
    String? query,
    String? categoryId,
    List<String> skills = const [],
    double? minBudget,
    double? maxBudget,
    int limit = 20,
    String? cursorAfterId,
  }) {
    if (limit < 1) throw ArgumentError.value(limit, 'limit');
    if (minBudget != null && !minBudget.isFinite ||
        maxBudget != null && !maxBudget.isFinite) {
      throw ArgumentError('Budget filters must be finite.');
    }
    if (minBudget != null && maxBudget != null && minBudget > maxBudget) {
      throw ArgumentError('Minimum budget cannot exceed maximum budget.');
    }
    return repository.getJobs(
      query: query,
      categoryId: categoryId,
      skills: skills,
      minBudget: minBudget,
      maxBudget: maxBudget,
      status: JobStatus.open,
      limit: limit,
      cursorAfterId: cursorAfterId,
    );
  }
}
