import 'package:worklyapp/domain/entities/user.dart';
import 'package:worklyapp/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  const GetProfileUseCase(this.repository);
  final ProfileRepository repository;

  Future<Object> execute(String userId) async {
    if (userId.trim().isEmpty) throw ArgumentError('User ID is required.');
    final user = await repository.getUser(userId);
    if (user == null) throw StateError('User not found.');
    return switch (user.role) {
      UserRole.client =>
        await repository.getClientProfile(userId) ??
            (throw StateError('Client profile not found.')),
      UserRole.freelancer =>
        await repository.getFreelancerProfile(userId) ??
            (throw StateError('Freelancer profile not found.')),
      UserRole.admin => user,
    };
  }
}
