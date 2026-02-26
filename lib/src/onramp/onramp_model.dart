class OnRampModel {
  final String status;
  final String transactionCode;
  final String message;

  OnRampModel({
    required this.status,
    required this.transactionCode,
    required this.message,
  });

  factory OnRampModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') ? json['data'] : json;
    return OnRampModel(
      status: data['status'],
      transactionCode: data['currency'],
      message: data['country_name'],
    );
  }

  @override
  String toString() => 'On ramp($transactionCode: $status - $message)';
}