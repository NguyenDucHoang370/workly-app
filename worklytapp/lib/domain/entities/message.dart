class Message {
  const Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.createdAt,
    this.text,
    this.fileUrl,
    this.isRead = false,
  });

  final String id;
  final String chatId;
  final String senderId;
  final DateTime createdAt;
  final String? text;
  final String? fileUrl;
  final bool isRead;

  Message copyWith({String? text, String? fileUrl, bool? isRead}) => Message(
    id: id,
    chatId: chatId,
    senderId: senderId,
    createdAt: createdAt,
    text: text ?? this.text,
    fileUrl: fileUrl ?? this.fileUrl,
    isRead: isRead ?? this.isRead,
  );
}
