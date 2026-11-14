import 'package:worklyapp/domain/entities/message.dart';
import 'package:worklyapp/domain/repositories/chat_repository.dart';

class SendChatMessageUseCase {
  static int _idSequence = 0;
  const SendChatMessageUseCase(this.repository);
  final ChatRepository repository;

  Future<Message> execute({
    required String chatId,
    required String senderId,
    String? text,
    String? fileUrl,
  }) async {
    final chat = await repository.getChatById(chatId);
    if (chat == null) throw StateError('Chat not found.');
    if (!chat.participantIds.contains(senderId)) {
      throw StateError('Only chat participants can send messages.');
    }
    final messageText = text?.trim();
    final attachment = fileUrl?.trim();
    if ((messageText == null || messageText.isEmpty) &&
        (attachment == null || attachment.isEmpty)) {
      throw ArgumentError('A message must contain text or a file.');
    }
    final now = DateTime.now();
    return repository.addMessage(
      Message(
        id: 'message_${now.microsecondsSinceEpoch}_${_idSequence++}',
        chatId: chatId,
        senderId: senderId,
        text: messageText?.isEmpty == true ? null : messageText,
        fileUrl: attachment?.isEmpty == true ? null : attachment,
        createdAt: now,
      ),
    );
  }
}
