class SubscriptionStatusModel {
  final bool hasActiveSubscription;
  final DateTime? activeSubscriptionEndsAt;

  SubscriptionStatusModel({
    required this.hasActiveSubscription,
    this.activeSubscriptionEndsAt,
  });

  factory SubscriptionStatusModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SubscriptionStatusModel(
      hasActiveSubscription:
          json['hasActiveSubscription'] as bool? ?? false,
      activeSubscriptionEndsAt:
          json['activeSubscriptionEndsAt'] != null
              ? DateTime.tryParse(
                  json['activeSubscriptionEndsAt'] as String,
                )
              : null,
    );
  }
}