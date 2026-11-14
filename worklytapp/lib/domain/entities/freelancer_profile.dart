class FreelancerProfile {
  FreelancerProfile({
    required this.userId,
    this.bio = '',
    List<String> skills = const [],
    this.hourlyRate,
    List<String> portfolio = const [],
    this.ratingAvg = 0,
    this.ratingCount = 0,
  }) : skills = List.unmodifiable(skills),
       portfolio = List.unmodifiable(portfolio);

  final String userId;
  final String bio;
  final List<String> skills;
  final double? hourlyRate;
  final List<String> portfolio;
  final double ratingAvg;
  final int ratingCount;

  FreelancerProfile copyWith({
    String? bio,
    List<String>? skills,
    double? hourlyRate,
    List<String>? portfolio,
    double? ratingAvg,
    int? ratingCount,
  }) => FreelancerProfile(
    userId: userId,
    bio: bio ?? this.bio,
    skills: skills ?? this.skills,
    hourlyRate: hourlyRate ?? this.hourlyRate,
    portfolio: portfolio ?? this.portfolio,
    ratingAvg: ratingAvg ?? this.ratingAvg,
    ratingCount: ratingCount ?? this.ratingCount,
  );
}
