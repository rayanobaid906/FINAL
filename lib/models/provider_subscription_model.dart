class ProviderSubscriptionModel {
  final int id;
  final int subscriptionPlanId;
  final String planName;
  final double planPrice;
  final int durationInDays;
  final DateTime startsAt;
  final DateTime endsAt;
  final DateTime createdAt;
  final bool isActive;

  ProviderSubscriptionModel({
    required this.id,
    required this.subscriptionPlanId,
    required this.planName,
    required this.planPrice,
    required this.durationInDays,
    required this.startsAt,
    required this.endsAt,
    required this.createdAt,
    required this.isActive,
  });

  factory ProviderSubscriptionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProviderSubscriptionModel(
      id: json['id'] as int,
      subscriptionPlanId: json['subscriptionPlanId'] as int,
      planName: json['planName'] as String? ?? '',
      planPrice: (json['planPrice'] as num).toDouble(),
      durationInDays: json['durationInDays'] as int,
      startsAt: DateTime.parse(json['startsAt'] as String),
      endsAt: DateTime.parse(json['endsAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isActive: json['isActive'] as bool? ?? false,
    );
  }
}