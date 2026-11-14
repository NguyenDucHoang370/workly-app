import 'package:workltapp/domain/entities/job.dart';
import 'package:workltapp/domain/entities/proposal.dart';
import 'package:workltapp/domain/repositories/job_repository.dart';

class SubmitProposalUseCase {
  static int _idSequence = 0;

  SubmitProposalUseCase(this.repository);

  final JobRepository repository;

  Future<Proposal> execute({
    required String jobId,
    required String freelancerId,
    required double price,
    required String coverLetter,
  }) async {
    if (jobId.trim().isEmpty) {
      throw ArgumentError('Job ID is required.');
    }
    if (freelancerId.trim().isEmpty) {
      throw ArgumentError('Freelancer ID is required.');
    }
    if (!price.isFinite || price <= 0) {
      throw ArgumentError('Proposal price must be greater than zero.');
    }
    if (coverLetter.trim().isEmpty) {
      throw ArgumentError('Cover letter is required.');
    }

    final job = await repository.getJobById(jobId);
    if (job == null) {
      throw StateError('Job not found.');
    }
    if (job.status != JobStatus.open) {
      throw StateError('Only open jobs can receive proposals.');
    }

    final existingProposals = await repository.getProposalsForJob(jobId);
    final hasExistingProposal = existingProposals.any(
      (proposal) =>
          proposal.freelancerId == freelancerId &&
          proposal.status != ProposalStatus.rejected,
    );

    if (hasExistingProposal) {
      throw StateError(
        'A freelancer cannot submit multiple active proposals for the same job.',
      );
    }

    final proposal = Proposal(
      id: 'proposal_${DateTime.now().microsecondsSinceEpoch}_${_idSequence++}',
      jobId: jobId,
      freelancerId: freelancerId,
      price: price,
      coverLetter: coverLetter.trim(),
      status: ProposalStatus.pending,
    );

    return repository.addProposal(proposal);
  }
}
