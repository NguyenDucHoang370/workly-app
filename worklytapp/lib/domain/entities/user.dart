enum UserRole { client, freelancer, admin }

class User {
  const User({
    required this.id,
    required this.email,
    required this.displayName,
    required this.role,
    required this.createdAt,
    this.avatarUrl,
  });

  final String id;
  final String email;
  final String displayName;
  final UserRole role;
  final DateTime createdAt;
  final String? avatarUrl;

  User copyWith({
    String? email,
    String? displayName,
    UserRole? role,
    DateTime? createdAt,
    String? avatarUrl,
    bool clearAvatarUrl = false,
  }) => User(
    id: id,
    email: email ?? this.email,
    displayName: displayName ?? this.displayName,
    role: role ?? this.role,
    createdAt: createdAt ?? this.createdAt,
    avatarUrl: clearAvatarUrl ? null : avatarUrl ?? this.avatarUrl,
  );
}
