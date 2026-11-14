import 'package:worklyapp/domain/entities/contract.dart';
import 'package:worklyapp/domain/entities/submission.dart';
import 'package:worklyapp/domain/repositories/contract_repository.dart';
import 'package:worklyapp/domain/repositories/submission_repository.dart';

class RequestSubmissionChangesUseCase {
  const RequestSubmissionChangesUseCase(this.contracts, this.submissions);
  final ContractRepository contracts;
  final SubmissionRepository submissions;

  Future<Submission> execute({
    required String contractId,
    required String clientId,
  }) async {
    final contract = await contracts.getContractById(contractId);
    if (contract == null) throw StateError('Contract not found.');
    if (contract.clientId != clientId) {
      throw StateError('Only the client can request changes.');
    }
    if (contract.status != ContractStatus.submitted) {
      throw StateError('Contract has no submission awaiting review.');
    }
    final items = await submissions.getSubmissionsForContract(contractId);
    if (items.isEmpty) throw StateError('Submission not found.');
    final latest = items.reduce(
      (a, b) => a.createdAt.isAfter(b.createdAt) ? a : b,
    );
    final updated = await submissions.updateSubmission(
      latest.copyWith(status: SubmissionStatus.changesRequested),
    );
    await contracts.updateContract(
      contract.copyWith(status: ContractStatus.changesRequested),
    );
    return updated;
  }
}
