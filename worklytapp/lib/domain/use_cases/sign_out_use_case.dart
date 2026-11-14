import 'package:worklyapp/domain/repositories/auth_repository.dart';

class SignOutUseCase {
  const SignOutUseCase(this.repository);
  final AuthRepository repository;
  Future<void> execute() => repository.signOut();
}
