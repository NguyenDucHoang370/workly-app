import 'package:worklyapp/domain/entities/contract.dart';

abstract class ContractRepository {
  Future<Contract?> getContractById(String contractId);
  Future<Contract?> getContractByProposalId(String proposalId);
  Future<List<Contract>> getContractsForUser(String userId);
  Future<Contract> createContract(Contract contract);
  Future<Contract> updateContract(Contract contract);
}
