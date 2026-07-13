class SubscriptionPaymentRequestModel {
  final int id;
  final int providerProfileId;
  final String providerName;
  final int subscriptionPlanId;
  final String planName;
  final double amount;
  final int paymentMethod;
  final String transactionId;
  final String? proofImageUrl;
  final int status;
  final DateTime createdAt;
  final DateTime? reviewedAt;
  final int? reviewedByAdminId;
  final String? reviewedByAdminName;
  final String? adminNote;

  SubscriptionPaymentRequestModel({
    required this.id,
    required this.providerProfileId,
    required this.providerName,
    required this.subscriptionPlanId,
    required this.planName,
    required this.amount,
    required this.paymentMethod,
    required this.transactionId,
    this.proofImageUrl,
    required this.status,
    required this.createdAt,
    this.reviewedAt,
    this.reviewedByAdminId,
    this.reviewedByAdminName,
    this.adminNote,
  });

  factory SubscriptionPaymentRequestModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SubscriptionPaymentRequestModel(
      id: json['id'] as int,
      providerProfileId: json['providerProfileId'] as int,
      providerName: json['providerName'] as String? ?? '',
      subscriptionPlanId: json['subscriptionPlanId'] as int,
      planName: json['planName'] as String? ?? '',
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as int,
      transactionId: json['transactionId'] as String? ?? '',
      proofImageUrl: json['proofImageUrl'] as String?,
      status: json['status'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.tryParse(json['reviewedAt'] as String)
          : null,
      reviewedByAdminId: json['reviewedByAdminId'] as int?,
      reviewedByAdminName: json['reviewedByAdminName'] as String?,
      adminNote: json['adminNote'] as String?,
    );
  }
}
