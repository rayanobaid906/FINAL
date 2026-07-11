class OrderModel {
  final int id;
  final int customerId;
  final String customerName;
  final String? customerPhoneNumber;

  final int specializationId;
  final String specializationName;

  final int? selectedProviderProfileId;
  final String? selectedProviderName;
  final String? selectedProviderPhoneNumber;

  final String description;
  final double latitude;
  final double longitude;
  final String? addressText;

  final int status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;

  OrderModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    this.customerPhoneNumber,
    required this.specializationId,
    required this.specializationName,
    this.selectedProviderProfileId,
    this.selectedProviderName,
    this.selectedProviderPhoneNumber,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.addressText,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.completedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int,
      customerId: json['customerId'] as int,
      customerName: json['customerName'] as String? ?? '',
      customerPhoneNumber: json['customerPhoneNumber'] as String?,
      specializationId: json['specializationId'] as int,
      specializationName: json['specializationName'] as String? ?? '',
      selectedProviderProfileId:
          json['selectedProviderProfileId'] as int?,
      selectedProviderName: json['selectedProviderName'] as String?,
      selectedProviderPhoneNumber:
          json['selectedProviderPhoneNumber'] as String?,
      description: json['description'] as String? ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      addressText: json['addressText'] as String?,
      status: json['status'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'] as String)
          : null,
    );
  }
}