class DisburseModel {
  final String status;
  final String transactionCode;
  final String message;

  DisburseModel({
    required this.status,
    required this.transactionCode,
    required this.message,
  });

  factory DisburseModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') ? json['data'] : json;
    return DisburseModel(
      status: data['status'],
      transactionCode: data['currency'],
      message: data['country_name'],
    );
  }

  @override
  String toString() => 'Disburse($transactionCode: $status - $message)';
}