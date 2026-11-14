import 'package:worklyapp/domain/entities/job.dart';
import 'package:worklyapp/domain/entities/proposal.dart';
import 'package:worklyapp/domain/entities/contract.dart';
import 'package:worklyapp/domain/repositories/contract_repository.dart';
import 'package:worklyapp/domain/repositories/job_repository.dart';
import 'package:worklyapp/domain/repositories/proposal_repository.dart';

class AcceptProposalUseCase {
  static int _idSequence = 0;

  const AcceptProposalUseCase(
    this.jobRepository,
    this.proposalRepository,
    this.contractRepository,
  );

  final JobRepository jobRepository;
  final ProposalRepository proposalRepository;
  final ContractRepository contractRepository;

  Future<Proposal> execute({
    required String clientId,
    required String jobId,
    required String proposalId,
  }) async {
    if (clientId.trim().isEmpty) throw ArgumentError('Client ID is required.');
    if (jobId.trim().isEmpty) {
      throw ArgumentError('Job ID is required.');
    }
    if (proposalId.trim().isEmpty) {
      throw ArgumentError('Proposal ID is required.');
    }

    final job = await jobRepository.getJobById(jobId);
    if (job == null) {
      throw StateError('Job not found.');
    }
    if (job.clientId != clientId) {
      throw StateError('Only the job owner can accept proposals.');
    }

    final proposals = await proposalRepository.getProposalsForJob(jobId);
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
    if (await contractRepository.getContractByProposalId(proposalId) != null) {
      throw StateError('A contract already exists for this proposal.');
    }

    final acceptedProposal = proposal.copyWith(status: ProposalStatus.accepted);
    final updatedProposal = await proposalRepository.updateProposal(
      acceptedProposal,
    );
    for (final otherProposal in proposals) {
      if (otherProposal.id != proposalId &&
          otherProposal.status == ProposalStatus.pending) {
        await proposalRepository.updateProposal(
          otherProposal.copyWith(status: ProposalStatus.rejected),
        );
      }
    }

    final now = DateTime.now();
    await contractRepository.createContract(
      Contract(
        id: 'contract_${now.microsecondsSinceEpoch}_${_idSequence++}',
        jobId: jobId,
        proposalId: proposalId,
        clientId: clientId,
        freelancerId: proposal.freelancerId,
        agreedPrice: proposal.price,
        status: ContractStatus.inProgress,
        startedAt: now,
      ),
    );

    final updatedJob = job.copyWith(status: JobStatus.inProgress);
    await jobRepository.updateJob(updatedJob);

    return updatedProposal;
  }
}
