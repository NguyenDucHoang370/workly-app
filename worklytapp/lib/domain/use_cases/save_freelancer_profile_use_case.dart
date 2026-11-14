import 'package:worklyapp/domain/entities/freelancer_profile.dart';
import 'package:worklyapp/domain/entities/user.dart';
import 'package:worklyapp/domain/repositories/profile_repository.dart';

class SaveFreelancerProfileUseCase {
  const SaveFreelancerProfileUseCase(this.repository);
  final ProfileRepository repository;

  Future<FreelancerProfile> execute(FreelancerProfile profile) async {
    if (profile.userId.trim().isEmpty) {
      throw ArgumentError('User ID is required.');
    }
    final user = await repository.getUser(profile.userId);
    if (user == null) throw StateError('User not found.');
    if (user.role != UserRole.freelancer) {
      throw StateError('Only freelancers can have a freelancer profile.');
    }
    if (profile.hourlyRate != null &&
        (!profile.hourlyRate!.isFinite || profile.hourlyRate! < 0)) {
      throw ArgumentError('Hourly rate must be a finite non-negative value.');
    }
    if (profile.ratingCount < 0 ||
        !profile.ratingAvg.isFinite ||
        profile.ratingAvg < 0 ||
        profile.ratingAvg > 5) {
      throw ArgumentError('Rating data is invalid.');
    }
    return repository.saveFreelancerProfile(profile);
  }
}
