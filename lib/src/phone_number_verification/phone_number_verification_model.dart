class PhoneNumberVerificationModel {
  final String status;
  final String shortCode;
  final String publicName;

  PhoneNumberVerificationModel({
    required this.status,
    required this.shortCode,
    required this.publicName,
  });

  factory PhoneNumberVerificationModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') ? json['data'] : json;
    return PhoneNumberVerificationModel(
      status: data["status"],
      shortCode: data['shortcode'],
      publicName: data['public_name'],
    );
  }

  @override
  String toString() => 'Verification Details($shortCode: $status - $publicName)';
}