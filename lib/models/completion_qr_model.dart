class CompletionQrModel {
  final int orderId;
  final String token;
  final DateTime expiresAt;

  CompletionQrModel({
    required this.orderId,
    required this.token,
    required this.expiresAt,
  });

  factory CompletionQrModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CompletionQrModel(
      orderId: json['orderId'] as int,
      token: json['token'] as String,
      expiresAt: DateTime.parse(
        json['expiresAt'] as String,
      ),
    );
  }
}