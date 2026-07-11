class SpecializationModel {
  final int id;
  final String name;
  final String? description;
  final bool isActive;
  final DateTime? createdAt;

  SpecializationModel({
    required this.id,
    required this.name,
    this.description,
    required this.isActive,
    this.createdAt,
  });

  factory SpecializationModel.fromJson(Map<String, dynamic> json) {
    return SpecializationModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}