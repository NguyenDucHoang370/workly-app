import 'package:worklyapp/domain/entities/client_profile.dart';
import 'package:worklyapp/domain/entities/user.dart';
import 'package:worklyapp/domain/repositories/profile_repository.dart';

class SaveClientProfileUseCase {
  const SaveClientProfileUseCase(this.repository);
  final ProfileRepository repository;

  Future<ClientProfile> execute(ClientProfile profile) async {
    if (profile.userId.trim().isEmpty) {
      throw ArgumentError('User ID is required.');
    }
    final user = await repository.getUser(profile.userId);
    if (user == null) throw StateError('User not found.');
    if (user.role != UserRole.client) {
      throw StateError('Only clients can have a client profile.');
    }
    return repository.saveClientProfile(profile);
  }
}
