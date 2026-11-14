import 'package:worklyapp/domain/entities/proposal.dart';
import 'package:worklyapp/domain/repositories/proposal_repository.dart';

class GetMyProposalsUseCase {
  const GetMyProposalsUseCase(this.repository);
  final ProposalRepository repository;

  Future<List<Proposal>> execute(String freelancerId) {
    if (freelancerId.trim().isEmpty) {
      throw ArgumentError('Freelancer ID is required.');
    }
    return repository.getProposalsByFreelancer(freelancerId);
  }
}
