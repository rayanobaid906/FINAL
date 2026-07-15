class AuthRefreshModel {
  final String accessToken;
  final String refreshToken;

  AuthRefreshModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthRefreshModel.fromJson(
      Map<String, dynamic> json) {
    return AuthRefreshModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}