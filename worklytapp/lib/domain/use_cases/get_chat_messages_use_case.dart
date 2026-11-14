import 'package:worklyapp/domain/entities/message.dart';
import 'package:worklyapp/domain/repositories/chat_repository.dart';

class GetChatMessagesUseCase {
  const GetChatMessagesUseCase(this.repository);
  final ChatRepository repository;

  Future<List<Message>> execute({
    required String chatId,
    required String userId,
    int limit = 50,
  }) async {
    final chat = await repository.getChatById(chatId);
    if (chat == null) throw StateError('Chat not found.');
    if (!chat.participantIds.contains(userId)) {
      throw StateError('Only chat participants can view messages.');
    }
    if (limit < 1) throw ArgumentError.value(limit, 'limit');
    return repository.getMessages(chatId, limit: limit);
  }
}
