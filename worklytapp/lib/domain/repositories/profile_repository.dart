import 'package:worklyapp/domain/entities/client_profile.dart';
import 'package:worklyapp/domain/entities/freelancer_profile.dart';
import 'package:worklyapp/domain/entities/user.dart';

abstract class ProfileRepository {
  Future<User?> getUser(String userId);
  Future<User> saveUser(User user);
  Future<ClientProfile?> getClientProfile(String userId);
  Future<ClientProfile> saveClientProfile(ClientProfile profile);
  Future<FreelancerProfile?> getFreelancerProfile(String userId);
  Future<FreelancerProfile> saveFreelancerProfile(FreelancerProfile profile);
}
