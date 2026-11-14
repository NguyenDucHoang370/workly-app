import 'package:workltapp/domain/entities/job.dart';
import 'package:workltapp/domain/entities/proposal.dart';
import 'package:workltapp/domain/repositories/job_repository.dart';

class InMemoryJobRepository implements JobRepository {
  final List<Job> _jobs = <Job>[];
  final Map<String, List<Proposal>> _proposalsByJobId = <String, List<Proposal>>{};

  @override
  Future<List<Job>> getJobs() async {
    return List<Job>.unmodifiable(_jobs);
  }

  @override
  Future<Job> createJob(Job job) async {
    _jobs.add(job);
    return job;
  }

  @override
  Future<Job?> getJobById(String jobId) async {
    return _jobs.firstWhere(
      (job) => job.id == jobId,
      orElse: () => throw StateError('Job not found.'),
    );
  }

  @override
  Future<List<Proposal>> getProposalsForJob(String jobId) async {
    return List<Proposal>.unmodifiable(_proposalsByJobId[jobId] ?? const <Proposal>[]);
  }

  @override
  Future<Proposal> addProposal(Proposal proposal) async {
    final list = _proposalsByJobId.putIfAbsent(proposal.jobId, () => <Proposal>[]);
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
