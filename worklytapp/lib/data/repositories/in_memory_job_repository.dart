import 'package:worklyapp/domain/entities/job.dart';
import 'package:worklyapp/domain/entities/proposal.dart';
import 'package:worklyapp/domain/repositories/job_repository.dart';
import 'package:worklyapp/domain/repositories/proposal_repository.dart';

class InMemoryJobRepository implements JobRepository, ProposalRepository {
  final List<Job> _jobs = <Job>[];
  final Map<String, List<Proposal>> _proposalsByJobId =
      <String, List<Proposal>>{};

  @override
  Future<List<Job>> getJobs({
    String? query,
    String? categoryId,
    List<String> skills = const [],
    double? minBudget,
    double? maxBudget,
    JobStatus? status,
    int limit = 20,
    String? cursorAfterId,
  }) async {
    if (limit < 1) throw ArgumentError.value(limit, 'limit');
    final normalizedQuery = query?.trim().toLowerCase();
    final normalizedSkills = skills.map((skill) => skill.toLowerCase()).toSet();
    final filtered = _jobs.where((job) {
      final matchesQuery =
          normalizedQuery == null ||
          normalizedQuery.isEmpty ||
          job.title.toLowerCase().contains(normalizedQuery) ||
          job.description.toLowerCase().contains(normalizedQuery);
      final matchesCategory =
          categoryId == null || job.categoryId == categoryId;
      final jobSkills = job.skills.map((skill) => skill.toLowerCase()).toSet();
      final matchesSkills =
          normalizedSkills.isEmpty ||
          normalizedSkills.every(jobSkills.contains);
      final matchesMin = minBudget == null || job.budgetMax >= minBudget;
      final matchesMax = maxBudget == null || job.budgetMin <= maxBudget;
      final matchesStatus = status == null || job.status == status;
      return matchesQuery &&
          matchesCategory &&
          matchesSkills &&
          matchesMin &&
          matchesMax &&
          matchesStatus;
    }).toList();

    final cursorIndex = cursorAfterId == null
        ? -1
        : filtered.indexWhere((job) => job.id == cursorAfterId);
    final start = cursorIndex < 0 ? 0 : cursorIndex + 1;
    if (start >= filtered.length) return const [];
    return List<Job>.unmodifiable(filtered.skip(start).take(limit));
  }

  @override
  Future<Job> createJob(Job job) async {
    if (_jobs.any((existing) => existing.id == job.id)) {
      throw StateError('Job ID already exists.');
    }
    _jobs.add(job);
    return job;
  }

  @override
  Future<Job?> getJobById(String jobId) async {
    final index = _jobs.indexWhere((job) => job.id == jobId);
    return index == -1 ? null : _jobs[index];
  }

  @override
  Future<Proposal?> getProposalById(String proposalId) async {
    for (final proposals in _proposalsByJobId.values) {
      for (final proposal in proposals) {
        if (proposal.id == proposalId) return proposal;
      }
    }
    return null;
  }

  @override
  Future<List<Proposal>> getProposalsForJob(String jobId) async {
    return List<Proposal>.unmodifiable(
      _proposalsByJobId[jobId] ?? const <Proposal>[],
    );
  }

  @override
  Future<List<Proposal>> getProposalsByFreelancer(String freelancerId) async {
    return List<Proposal>.unmodifiable(
      _proposalsByJobId.values
          .expand((items) => items)
          .where((proposal) => proposal.freelancerId == freelancerId),
    );
  }

  @override
  Future<Proposal> addProposal(Proposal proposal) async {
    final list = _proposalsByJobId.putIfAbsent(
      proposal.jobId,
      () => <Proposal>[],
    );
    if (list.any((existing) => existing.id == proposal.id)) {
      throw StateError('Proposal ID already exists for this job.');
    }
    list.add(proposal);
    return proposal;
  }

  @override
  Future<Proposal> updateProposal(Proposal proposal) async {
    final list = _proposalsByJobId[proposal.jobId] ?? <Proposal>[];
    final index = list.indexWhere((item) => item.id == proposal.id);
    if (index == -1) {
      throw StateError('Proposal not found in repository.');
    }
    list[index] = proposal;
    return proposal;
  }

  @override
  Future<Job> updateJob(Job job) async {
    final index = _jobs.indexWhere((item) => item.id == job.id);
    if (index == -1) {
      throw StateError('Job not found in repository.');
    }
    _jobs[index] = job;
    return job;
  }
}
