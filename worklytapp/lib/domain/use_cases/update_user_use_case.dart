import 'package:worklyapp/domain/entities/user.dart';
import 'package:worklyapp/domain/repositories/profile_repository.dart';

class UpdateUserUseCase {
  const UpdateUserUseCase(this.repository);
  final ProfileRepository repository;

  Future<User> execute({
    required String requesterId,
    required User user,
  }) async {
    if (requesterId != user.id) {
      throw StateError('Users can only update their own account.');
    }
    final existing = await repository.getUser(user.id);
    if (existing == null) throw StateError('User not found.');
    if (existing.role != user.role) {
      throw StateError('Account role cannot be changed here.');
    }
    if (user.email.trim().isEmpty ||
        !user.email.contains('@') ||
        user.displayName.trim().isEmpty) {
      throw ArgumentError('A valid email and display name are required.');
    }
    return repository.saveUser(
      user.copyWith(
        email: user.email.trim().toLowerCase(),
        displayName: user.displayName.trim(),
      ),
    );
  }
}
