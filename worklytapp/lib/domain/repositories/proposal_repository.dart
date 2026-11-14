import 'package:worklyapp/domain/entities/proposal.dart';

abstract class ProposalRepository {
  Future<Proposal?> getProposalById(String proposalId);
  Future<List<Proposal>> getProposalsForJob(String jobId);
  Future<List<Proposal>> getProposalsByFreelancer(String freelancerId);
  Future<Proposal> addProposal(Proposal proposal);
  Future<Proposal> updateProposal(Proposal proposal);
}
