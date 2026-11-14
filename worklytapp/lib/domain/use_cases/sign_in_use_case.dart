import 'package:worklyapp/domain/entities/user.dart';
import 'package:worklyapp/domain/repositories/auth_repository.dart';

class SignInUseCase {
  const SignInUseCase(this.repository);
  final AuthRepository repository;

  Future<User> execute({required String email, required String password}) {
    if (email.trim().isEmpty || !email.contains('@') || password.isEmpty) {
      throw ArgumentError('A valid email and password are required.');
    }
    return repository.signIn(
      email: email.trim().toLowerCase(),
      password: password,
    );
  }
}
