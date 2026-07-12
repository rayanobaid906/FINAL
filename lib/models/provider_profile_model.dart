class ProviderProfileModel {
  final int id;
  final int userId;
  final String fullName;
  final String phoneNumber;
  final int specializationId;
  final String specializationName;
  final String? bio;
  final DateTime createdAt;

  ProviderProfileModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.specializationId,
    required this.specializationName,
    this.bio,
    required this.createdAt,
  });

  factory ProviderProfileModel.fromJson(Map<String, dynamic> json) {
    return ProviderProfileModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      fullName: json['fullName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      specializationId: json['specializationId'] as int,
      specializationName: json['specializationName'] as String? ?? '',
      bio: json['bio'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}