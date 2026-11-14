import 'package:worklyapp/domain/entities/job.dart';
import 'package:worklyapp/domain/entities/proposal.dart';
import 'package:worklyapp/domain/repositories/job_repository.dart';
import 'package:worklyapp/domain/repositories/proposal_repository.dart';

class RejectProposalUseCase {
  const RejectProposalUseCase(this.jobs, this.proposals);
  final JobRepository jobs;
  final ProposalRepository proposals;

  Future<Proposal> execute({
    required String jobId,
    required String proposalId,
    required String clientId,
  }) async {
    final job = await jobs.getJobById(jobId);
    if (job == null) throw StateError('Job not found.');
    if (job.clientId != clientId) {
      throw StateError('Only the job owner can reject proposals.');
    }
    if (job.status != JobStatus.open) {
      throw StateError('Proposals can only be rejected for open jobs.');
    }
    final proposal = await proposals.getProposalById(proposalId);
    if (proposal == null || proposal.jobId != jobId) {
      throw StateError('Proposal not found for this job.');
    }
    if (proposal.status != ProposalStatus.pending) {
      throw StateError('Only pending proposals can be rejected.');
    }
    return proposals.updateProposal(
      proposal.copyWith(status: ProposalStatus.rejected),
    );
  }
}
