class SupportedBanksModel {
  final String name;
  dynamic code;

  SupportedBanksModel({
    required this.name,
    required this.code,
  });

  factory SupportedBanksModel.fromJson(Map<String, dynamic> json) {
    return SupportedBanksModel(
      name: json['Name'],
      code: json['Code'],
    );
  }

  @override
  String toString() => 'SupportedBanks($name, code: $code)';
}