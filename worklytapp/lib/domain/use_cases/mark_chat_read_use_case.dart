import 'package:worklyapp/domain/repositories/chat_repository.dart';

class MarkChatReadUseCase {
  const MarkChatReadUseCase(this.repository);
  final ChatRepository repository;

  Future<void> execute({required String chatId, required String userId}) async {
    final chat = await repository.getChatById(chatId);
    if (chat == null) throw StateError('Chat not found.');
    if (!chat.participantIds.contains(userId)) {
      throw StateError('Only chat participants can mark messages read.');
    }
    await repository.markMessagesRead(chatId, userId);
  }
}
