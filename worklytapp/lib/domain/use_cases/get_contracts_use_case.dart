import 'package:worklyapp/domain/entities/contract.dart';
import 'package:worklyapp/domain/repositories/contract_repository.dart';

class GetContractsUseCase {
  const GetContractsUseCase(this.repository);
  final ContractRepository repository;
  Future<List<Contract>> execute(String userId) {
    if (userId.trim().isEmpty) throw ArgumentError('User ID is required.');
    return repository.getContractsForUser(userId);
  }
}
