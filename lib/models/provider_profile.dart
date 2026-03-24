class ProviderProfile {
  final String id;
  final String userId;
  final String serviceId;
  final String? bio;
  final int experienceYears;
  final bool isApproved;
  final bool isAvailable;
  final bool isOnline;
  final double ratingAvg;
  final int ratingCount;
  final int totalJobs;
  final double completionRate;
  final double responseRate;

  ProviderProfile({required this.id, required this.userId, required this.serviceId, this.bio,
    required this.experienceYears, required this.isApproved, required this.isAvailable,
    required this.isOnline, required this.ratingAvg, required this.ratingCount,
    required this.totalJobs, required this.completionRate, required this.responseRate});

  factory ProviderProfile.fromJson(Map<String, dynamic> json) => ProviderProfile(
    id: json['id'], userId: json['userId'], serviceId: json['serviceId'],
    bio: json['bio'], experienceYears: json['experienceYears'] ?? 0,
    isApproved: json['isApproved'] ?? false, isAvailable: json['isAvailable'] ?? true,
    isOnline: json['isOnline'] ?? false, ratingAvg: (json['ratingAvg'] ?? 0).toDouble(),
    ratingCount: json['ratingCount'] ?? 0, totalJobs: json['totalJobs'] ?? 0,
    completionRate: (json['completionRate'] ?? 0).toDouble(),
    responseRate: (json['responseRate'] ?? 0).toDouble(),
  );
}
