import 'package:worklyapp/domain/entities/category.dart';
import 'package:worklyapp/domain/entities/chat.dart';
import 'package:worklyapp/domain/entities/client_profile.dart';
import 'package:worklyapp/domain/entities/favorite.dart';
import 'package:worklyapp/domain/entities/freelancer_profile.dart';
import 'package:worklyapp/domain/entities/message.dart';
import 'package:worklyapp/domain/entities/notification.dart';
import 'package:worklyapp/domain/entities/review.dart';
import 'package:worklyapp/domain/entities/submission.dart';
import 'package:worklyapp/domain/entities/user.dart';
import 'package:worklyapp/domain/repositories/category_repository.dart';
import 'package:worklyapp/domain/repositories/chat_repository.dart';
import 'package:worklyapp/domain/repositories/favorite_repository.dart';
import 'package:worklyapp/domain/repositories/notification_repository.dart';
import 'package:worklyapp/domain/repositories/profile_repository.dart';
import 'package:worklyapp/domain/repositories/review_repository.dart';
import 'package:worklyapp/domain/repositories/submission_repository.dart';

/// Local in-memory adapter for demos and unit tests; it does not persist data.
class InMemoryWorkRepository
    implements
        ProfileRepository,
        CategoryRepository,
        SubmissionRepository,
        ChatRepository,
        ReviewRepository,
        NotificationRepository,
        FavoriteRepository {
  final Map<String, User> _users = {};
  final Map<String, ClientProfile> _clientProfiles = {};
  final Map<String, FreelancerProfile> _freelancerProfiles = {};
  final List<Category> _categories = [];
  final Map<String, Submission> _submissions = {};
  final Map<String, Chat> _chats = {};
  final Map<String, List<Message>> _messages = {};
  final Map<String, Review> _reviews = {};
  final Map<String, AppNotification> _notifications = {};
  final Map<String, Favorite> _favorites = {};

  @override
  Future<User?> getUser(String userId) async => _users[userId];

  @override
  Future<User> saveUser(User user) async => _users[user.id] = user;

  @override
  Future<ClientProfile?> getClientProfile(String userId) async =>
      _clientProfiles[userId];

  @override
  Future<ClientProfile> saveClientProfile(ClientProfile profile) async =>
      _clientProfiles[profile.userId] = profile;

  @override
  Future<FreelancerProfile?> getFreelancerProfile(String userId) async =>
      _freelancerProfiles[userId];

  @override
  Future<FreelancerProfile> saveFreelancerProfile(
    FreelancerProfile profile,
  ) async => _freelancerProfiles[profile.userId] = profile;

  void seedCategory(Category category) => _categories.add(category);

  @override
  Future<List<Category>> getCategories() async =>
      List.unmodifiable(_categories);

  @override
  Future<List<Submission>> getSubmissionsForContract(String contractId) async =>
      List.unmodifiable(
        _submissions.values.where((item) => item.contractId == contractId),
      );

  @override
  Future<Submission> createSubmission(Submission submission) async {
    if (_submissions.containsKey(submission.id)) {
      throw StateError('Submission ID already exists.');
    }
    _submissions[submission.id] = submission;
    return submission;
  }

  @override
  Future<Submission> updateSubmission(Submission submission) async {
    if (!_submissions.containsKey(submission.id)) {
      throw StateError('Submission not found.');
    }
    _submissions[submission.id] = submission;
    return submission;
  }

  @override
  Future<Chat?> getChatById(String chatId) async => _chats[chatId];

  @override
  Future<Chat?> getChatForJobAndParticipants(
    String jobId,
    List<String> participantIds,
  ) async {
    final expected = participantIds.toSet();
    for (final chat in _chats.values) {
      if (chat.jobId == jobId &&
          chat.participantIds.toSet().containsAll(expected) &&
          expected.containsAll(chat.participantIds)) {
        return chat;
      }
    }
    return null;
  }

  @override
  Future<List<Chat>> getChatsForUser(String userId) async => List.unmodifiable(
    _chats.values.where((chat) => chat.participantIds.contains(userId)),
  );

  @override
  Future<Chat> createChat(Chat chat) async {
    if (_chats.containsKey(chat.id)) {
      throw StateError('Chat ID already exists.');
    }
    _chats[chat.id] = chat;
    _messages.putIfAbsent(chat.id, () => []);
    return chat;
  }

  @override
  Future<List<Message>> getMessages(String chatId, {int limit = 50}) async {
    final items = List<Message>.of(_messages[chatId] ?? const [])
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return List.unmodifiable(items.take(limit));
  }

  @override
  Future<Message> addMessage(Message message) async {
    final chat = _chats[message.chatId];
    if (chat == null) throw StateError('Chat not found.');
    final messages = _messages.putIfAbsent(message.chatId, () => []);
    if (messages.any((item) => item.id == message.id)) {
      throw StateError('Message ID already exists.');
    }
    messages.add(message);
    _chats[chat.id] = chat.copyWith(
      lastMessage: message.text ?? message.fileUrl,
      updatedAt: message.createdAt,
    );
    return message;
  }

  @override
  Future<void> markMessagesRead(String chatId, String readerId) async {
    final messages = _messages[chatId];
    if (messages == null) return;
    for (var index = 0; index < messages.length; index++) {
      final message = messages[index];
      if (message.senderId != readerId && !message.isRead) {
        messages[index] = message.copyWith(isRead: true);
      }
    }
  }

  @override
  Future<Review?> getReviewFromUserForContract(
    String contractId,
    String fromUserId,
  ) async {
    for (final review in _reviews.values) {
      if (review.contractId == contractId && review.fromUserId == fromUserId) {
        return review;
      }
    }
    return null;
  }

  @override
  Future<List<Review>> getReviewsForUser(String userId) async =>
      List.unmodifiable(
        _reviews.values.where((item) => item.toUserId == userId),
      );

  @override
  Future<Review> createReview(Review review) async {
    if (_reviews.containsKey(review.id) ||
        await getReviewFromUserForContract(
              review.contractId,
              review.fromUserId,
            ) !=
            null) {
      throw StateError('Review already exists.');
    }
    _reviews[review.id] = review;
    return review;
  }

  void seedNotification(AppNotification notification) =>
      _notifications[notification.id] = notification;

  @override
  Future<List<AppNotification>> getNotifications(
    String userId, {
    bool unreadOnly = false,
  }) async => List.unmodifiable(
    _notifications.values.where(
      (item) => item.userId == userId && (!unreadOnly || !item.isRead),
    ),
  );

  @override
  Future<AppNotification> updateNotification(
    AppNotification notification,
  ) async {
    if (!_notifications.containsKey(notification.id)) {
      throw StateError('Notification not found.');
    }
    _notifications[notification.id] = notification;
    return notification;
  }

  @override
  Future<void> markAllRead(String userId) async {
    for (final item in await getNotifications(userId, unreadOnly: true)) {
      _notifications[item.id] = item.copyWith(isRead: true);
    }
  }

  String _favoriteKey(
    String userId,
    FavoriteTargetType type,
    String targetId,
  ) => '$userId|${type.name}|$targetId';

  @override
  Future<List<Favorite>> getFavorites(String userId) async => List.unmodifiable(
    _favorites.values.where((item) => item.userId == userId),
  );

  @override
  Future<bool> containsFavorite(
    String userId,
    FavoriteTargetType type,
    String targetId,
  ) async => _favorites.containsKey(_favoriteKey(userId, type, targetId));

  @override
  Future<Favorite> addFavorite(Favorite favorite) async {
    final key = _favoriteKey(
      favorite.userId,
      favorite.targetType,
      favorite.targetId,
    );
    if (_favorites.containsKey(key)) {
      throw StateError('Favorite already exists.');
    }
    _favorites[key] = favorite;
    return favorite;
  }

  @override
  Future<void> removeFavorite(
    String userId,
    FavoriteTargetType type,
    String targetId,
  ) async {
    _favorites.remove(_favoriteKey(userId, type, targetId));
  }
}
