class RatingSummaryModel {
  final int providerProfileId;
  final double averageRating;
  final int ratingsCount;
  final int completedOrdersCount;

  RatingSummaryModel({
    required this.providerProfileId,
    required this.averageRating,
    required this.ratingsCount,
    required this.completedOrdersCount,
  });

  factory RatingSummaryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return RatingSummaryModel(
      providerProfileId:
          json['providerProfileId'] as int,
      averageRating:
          (json['averageRating'] as num).toDouble(),
      ratingsCount:
          json['ratingsCount'] as int? ?? 0,
      completedOrdersCount:
          json['completedOrdersCount'] as int? ?? 0,
    );
  }
}