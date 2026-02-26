class CountryModel {
  final int id;
  final String name;
  final String currencyCode;
  final String phoneCode;

  CountryModel({
    required this.id,
    required this.name,
    required this.currencyCode,
    required this.phoneCode,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'],
      name: json['name'],
      currencyCode: json['currency_code'],
      phoneCode: json['phone_code'],
    );
  }

  @override
  String toString() => 'CountryModel($name, $currencyCode, +$phoneCode)';
}