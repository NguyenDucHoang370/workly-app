import 'package:flutter_test/flutter_test.dart';
import 'package:worklyapp/domain/entities/freelancer_profile.dart';
import 'package:worklyapp/domain/entities/job.dart';

void main() {
  test(
    'Job copyWith preserves immutable values and updates selected fields',
    () {
      final job = Job(
        id: 'job-1',
        clientId: 'client-1',
        title: 'Original',
        description: 'Description',
        category: 'Mobile',
        skills: const ['Dart'],
        budgetMin: 10,
        budgetMax: 20,
        deadline: DateTime.utc(2027),
        createdAt: DateTime.utc(2026),
      );
      final updated = job.copyWith(title: 'Updated', status: JobStatus.closed);
      expect(updated.id, job.id);
      expect(updated.title, 'Updated');
      expect(updated.createdAt, job.createdAt);
      expect(updated.status, JobStatus.closed);
    },
  );

  test('Freelancer profile protects list fields from external mutation', () {
    final skills = <String>['Dart'];
    final profile = FreelancerProfile(userId: 'user-1', skills: skills);
    skills.add('Injected');
    expect(profile.skills, ['Dart']);
    expect(() => profile.skills.add('Blocked'), throwsUnsupportedError);
  });
}
