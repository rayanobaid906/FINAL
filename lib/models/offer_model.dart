class OfferModel {
  final int id;
  final int orderId;
  final String orderDescription;
  final int orderStatus;

  final int providerProfileId;
  final String providerName;
  final String? providerPhoneNumber;

  final String specializationName;

  final String customerName;
  final String? customerPhoneNumber;

  final double inspectionPrice;
  final String? note;

  final double providerLatitude;
  final double providerLongitude;

  final int status;

  final double averageRating;
  final int ratingsCount;
  final int completedOrdersCount;

  final DateTime createdAt;
  final DateTime? updatedAt;

  OfferModel({
    required this.id,
    required this.orderId,
    required this.orderDescription,
    required this.orderStatus,
    required this.providerProfileId,
    required this.providerName,
    this.providerPhoneNumber,
    required this.specializationName,
    required this.customerName,
    this.customerPhoneNumber,
    required this.inspectionPrice,
    this.note,
    required this.providerLatitude,
    required this.providerLongitude,
    required this.status,
    required this.averageRating,
    required this.ratingsCount,
    required this.completedOrdersCount,
    required this.createdAt,
    this.updatedAt,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] as int,
      orderId: json['orderId'] as int,
      orderDescription: json['orderDescription'] as String? ?? '',
      orderStatus: json['orderStatus'] as int,
      providerProfileId: json['providerProfileId'] as int,
      providerName: json['providerName'] as String? ?? '',
      providerPhoneNumber: json['providerPhoneNumber'] as String?,
      specializationName: json['specializationName'] as String? ?? '',
      customerName: json['customerName'] as String? ?? '',
      customerPhoneNumber: json['customerPhoneNumber'] as String?,
      inspectionPrice: (json['inspectionPrice'] as num).toDouble(),
      note: json['note'] as String?,
      providerLatitude:
          (json['providerLatitude'] as num).toDouble(),
      providerLongitude:
          (json['providerLongitude'] as num).toDouble(),
      status: json['status'] as int,
      averageRating:
          (json['averageRating'] as num?)?.toDouble() ?? 0,
      ratingsCount: json['ratingsCount'] as int? ?? 0,
      completedOrdersCount:
          json['completedOrdersCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }
}