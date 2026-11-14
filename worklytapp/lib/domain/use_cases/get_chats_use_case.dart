import 'package:worklyapp/domain/entities/chat.dart';
import 'package:worklyapp/domain/repositories/chat_repository.dart';

class GetChatsUseCase {
  const GetChatsUseCase(this.repository);
  final ChatRepository repository;

  Future<List<Chat>> execute(String userId) {
    if (userId.trim().isEmpty) throw ArgumentError('User ID is required.');
    return repository.getChatsForUser(userId);
  }
}
