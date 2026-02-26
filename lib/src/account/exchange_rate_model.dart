class ExchangeRateModel {
  final String from;
  final String to;
  final double rate;

  ExchangeRateModel({
    required this.from,
    required this.to,
    required this.rate,
  });

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return ExchangeRateModel(
      from: data['from'],
      to: data['to'],
      rate: (data['rate'] as num).toDouble(),
    );
  }

  @override
  String toString() => 'ExchangeRate(1 $from = $rate $to)';
}