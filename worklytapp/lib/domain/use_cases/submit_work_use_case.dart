import 'package:worklyapp/domain/entities/contract.dart';
import 'package:worklyapp/domain/entities/submission.dart';
import 'package:worklyapp/domain/repositories/contract_repository.dart';
import 'package:worklyapp/domain/repositories/submission_repository.dart';

class SubmitWorkUseCase {
  static int _idSequence = 0;
  const SubmitWorkUseCase(this.contracts, this.submissions);
  final ContractRepository contracts;
  final SubmissionRepository submissions;

  Future<Submission> execute({
    required String contractId,
    required String freelancerId,
    required List<String> files,
    required String note,
  }) async {
    final contract = await contracts.getContractById(contractId);
    if (contract == null) throw StateError('Contract not found.');
    if (contract.freelancerId != freelancerId) {
      throw StateError('Only the assigned freelancer can submit work.');
    }
    if (contract.status != ContractStatus.inProgress &&
        contract.status != ContractStatus.changesRequested) {
      throw StateError(
        'Work cannot be submitted in the current contract state.',
      );
    }
    final cleanFiles = files
        .map((file) => file.trim())
        .where((file) => file.isNotEmpty)
        .toList();
    if (cleanFiles.isEmpty && note.trim().isEmpty) {
      throw ArgumentError('Add a note or at least one file.');
    }
    final now = DateTime.now();
    final submission = Submission(
      id: 'submission_${now.microsecondsSinceEpoch}_${_idSequence++}',
      contractId: contractId,
      files: cleanFiles,
      note: note.trim(),
      status: SubmissionStatus.submitted,
      createdAt: now,
    );
    final created = await submissions.createSubmission(submission);
    await contracts.updateContract(
      contract.copyWith(status: ContractStatus.submitted),
    );
    return created;
  }
}
