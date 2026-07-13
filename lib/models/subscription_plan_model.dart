class SubscriptionPlanModel {
  final int id;
  final String name;
  final double price;
  final int durationInDays;
  final bool isActive;
  final DateTime createdAt;

  SubscriptionPlanModel({
    required this.id,
    required this.name,
    required this.price,
    required this.durationInDays,
    required this.isActive,
    required this.createdAt,
  });

  factory SubscriptionPlanModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SubscriptionPlanModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      durationInDays: json['durationInDays'] as int,
      isActive: json['isActive'] as bool? ?? false,
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
    );
  }
}