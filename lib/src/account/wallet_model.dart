class WalletModel {
  final int id;
  final double balance;
  final String currency;
  final String countryName;

  WalletModel({
    required this.id,
    required this.balance,
    required this.currency,
    required this.countryName,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') ? json['data'] : json;
    return WalletModel(
      id: data['id'],
      balance: double.parse(data['balance'].toString()),
      currency: data['currency'],
      countryName: data['country_name'],
    );
  }

  @override
  String toString() => 'Wallet($currency: $balance - $countryName)';
}