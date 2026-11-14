import 'package:worklyapp/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> signUp({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  });
  Future<User> signIn({required String email, required String password});
  Future<User> signInWithGoogle();
  Future<void> sendPasswordReset(String email);
  Future<void> signOut();
  Future<User?> getCurrentUser();
}
