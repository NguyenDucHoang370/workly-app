import 'package:workltapp/domain/entities/job.dart';
import 'package:workltapp/domain/entities/proposal.dart';
import 'package:workltapp/domain/repositories/job_repository.dart';

class AcceptProposalUseCase {
  AcceptProposalUseCase(this.repository);

  final JobRepository repository;

  Future<Proposal> execute({
    required String jobId,
    required String proposalId,
  }) async {
    if (jobId.trim().isEmpty) {
      throw ArgumentError('Job ID is required.');
    }
    if (proposalId.trim().isEmpty) {
      throw ArgumentError('Proposal ID is required.');
    }

    final job = await repository.getJobById(jobId);
    if (job == null) {
      throw StateError('Job not found.');
    }

    final proposals = await repository.getProposalsForJob(jobId);
    final proposal = proposals.firstWhere(
      (item) => item.id == proposalId,
      orElse: () => throw StateError('Proposal not found for this job.'),
    );

    if (proposal.status != ProposalStatus.pending) {
      throw StateError('Only pending proposals can be accepted.');
    }

    if (job.status != JobStatus.open) {
      throw StateError('The job must be open before accepting a proposal.');
    }

    final acceptedProposal = proposal.copyWith(status: ProposalStatus.accepted);
    final updatedProposal = await repository.updateProposal(acceptedProposal);

    final updatedJob = job.copyWith(status: JobStatus.inProgress);
    await repository.updateJob(updatedJob);

    return updatedProposal;
  }
}
