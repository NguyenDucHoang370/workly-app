import 'package:worklyapp/domain/entities/chat.dart';
import 'package:worklyapp/domain/entities/message.dart';

abstract class ChatRepository {
  Future<Chat?> getChatById(String chatId);
  Future<Chat?> getChatForJobAndParticipants(
    String jobId,
    List<String> participantIds,
  );
  Future<List<Chat>> getChatsForUser(String userId);
  Future<Chat> createChat(Chat chat);
  Future<List<Message>> getMessages(String chatId, {int limit = 50});
  Future<Message> addMessage(Message message);
  Future<void> markMessagesRead(String chatId, String readerId);
}
