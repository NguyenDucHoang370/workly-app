import 'package:worklyapp/domain/entities/user.dart';
import 'package:worklyapp/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  const SignUpUseCase(this.repository);
  final AuthRepository repository;

  Future<User> execute({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  }) {
    if (!email.contains('@') || email.trim().isEmpty) {
      throw ArgumentError('A valid email is required.');
    }
    if (password.length < 8) {
      throw ArgumentError('Password must contain at least 8 characters.');
    }
    if (displayName.trim().isEmpty) {
      throw ArgumentError('Display name is required.');
    }
    return repository.signUp(
      email: email.trim().toLowerCase(),
      password: password,
      displayName: displayName.trim(),
      role: role,
    );
  }
}
