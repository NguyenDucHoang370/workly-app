import 'package:worklyapp/domain/entities/user.dart';
import 'package:worklyapp/domain/repositories/auth_repository.dart';

class SignInWithGoogleUseCase {
  const SignInWithGoogleUseCase(this.repository);
  final AuthRepository repository;
  Future<User> execute() => repository.signInWithGoogle();
}
