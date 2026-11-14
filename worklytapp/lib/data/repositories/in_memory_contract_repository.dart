import 'package:worklyapp/domain/entities/contract.dart';
import 'package:worklyapp/domain/repositories/contract_repository.dart';

class InMemoryContractRepository implements ContractRepository {
  final Map<String, Contract> _contracts = {};

  @override
  Future<Contract?> getContractById(String contractId) async =>
      _contracts[contractId];

  @override
  Future<Contract?> getContractByProposalId(String proposalId) async {
    for (final contract in _contracts.values) {
      if (contract.proposalId == proposalId) return contract;
    }
    return null;
  }

  @override
  Future<List<Contract>> getContractsForUser(String userId) async =>
      List.unmodifiable(
        _contracts.values.where(
          (contract) =>
              contract.clientId == userId || contract.freelancerId == userId,
        ),
      );

  @override
  Future<Contract> createContract(Contract contract) async {
    if (_contracts.containsKey(contract.id) ||
        await getContractByProposalId(contract.proposalId) != null) {
      throw StateError('A contract already exists for this ID or proposal.');
    }
    _contracts[contract.id] = contract;
    return contract;
  }

  @override
  Future<Contract> updateContract(Contract contract) async {
    if (!_contracts.containsKey(contract.id)) {
      throw StateError('Contract not found.');
    }
    _contracts[contract.id] = contract;
    return contract;
  }
}
