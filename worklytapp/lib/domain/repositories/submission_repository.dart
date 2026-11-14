import 'package:worklyapp/domain/entities/submission.dart';

abstract class SubmissionRepository {
  Future<List<Submission>> getSubmissionsForContract(String contractId);
  Future<Submission> createSubmission(Submission submission);
  Future<Submission> updateSubmission(Submission submission);
}
