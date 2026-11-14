import 'package:worklyapp/domain/repositories/auth_repository.dart';

class SendPasswordResetUseCase {
  const SendPasswordResetUseCase(this.repository);
  final AuthRepository repository;

  Future<void> execute(String email) {
    if (email.trim().isEmpty || !email.contains('@')) {
      throw ArgumentError('A valid email is required.');
    }
    return repository.sendPasswordReset(email.trim().toLowerCase());
  }
}
