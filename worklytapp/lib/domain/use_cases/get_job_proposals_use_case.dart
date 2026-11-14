import 'package:worklyapp/domain/entities/proposal.dart';
import 'package:worklyapp/domain/repositories/job_repository.dart';
import 'package:worklyapp/domain/repositories/proposal_repository.dart';

class GetJobProposalsUseCase {
  const GetJobProposalsUseCase(this.jobs, this.proposals);
  final JobRepository jobs;
  final ProposalRepository proposals;

  Future<List<Proposal>> execute({
    required String jobId,
    required String clientId,
  }) async {
    final job = await jobs.getJobById(jobId);
    if (job == null) throw StateError('Job not found.');
    if (job.clientId != clientId) {
      throw StateError('Only the job owner can view proposals.');
    }
    return proposals.getProposalsForJob(jobId);
  }
}
