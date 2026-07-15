class NotificationModel {
  final int id;
  final String title;
  final String message;
  final int type;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;
  final int? relatedOrderId;
  final int? relatedOfferId;
  final int? relatedSubscriptionPaymentRequestId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.readAt,
    this.relatedOrderId,
    this.relatedOfferId,
    this.relatedSubscriptionPaymentRequestId,
  });

  factory NotificationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return NotificationModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      type: json['type'] as int? ?? 0,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
      readAt: json['readAt'] != null
          ? DateTime.tryParse(
              json['readAt'] as String,
            )
          : null,
      relatedOrderId: json['relatedOrderId'] as int?,
      relatedOfferId: json['relatedOfferId'] as int?,
      relatedSubscriptionPaymentRequestId:
          json['relatedSubscriptionPaymentRequestId'] as int?,
    );
  }
}