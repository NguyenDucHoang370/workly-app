import 'package:worklyapp/domain/entities/contract.dart';
import 'package:worklyapp/domain/repositories/contract_repository.dart';

class GetContractUseCase {
  const GetContractUseCase(this.repository);
  final ContractRepository repository;

  Future<Contract> execute({
    required String contractId,
    required String userId,
  }) async {
    final contract = await repository.getContractById(contractId);
    if (contract == null) throw StateError('Contract not found.');
    if (userId != contract.clientId && userId != contract.freelancerId) {
      throw StateError('Only contract participants can view it.');
    }
    return contract;
  }
}
