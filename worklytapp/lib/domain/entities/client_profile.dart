class ClientProfile {
  const ClientProfile({required this.userId, this.company, this.location});

  final String userId;
  final String? company;
  final String? location;

  ClientProfile copyWith({String? company, String? location}) => ClientProfile(
    userId: userId,
    company: company ?? this.company,
    location: location ?? this.location,
  );
}
