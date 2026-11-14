import 'package:workltapp/domain/entities/job.dart';
import 'package:workltapp/domain/entities/proposal.dart';

abstract class JobRepository {
  Future<List<Job>> getJobs();

  Future<Job> createJob(Job job);

  Future<Job?> getJobById(String jobId);

  Future<List<Proposal>> getProposalsForJob(String jobId);

  Future<Proposal> addProposal(Proposal proposal);

  Future<Proposal> updateProposal(Proposal proposal);

  Future<Job> updateJob(Job job);
}
