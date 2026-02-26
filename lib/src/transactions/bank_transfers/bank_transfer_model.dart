class BankTransferModel {
  final String status;
  final String transactionCode;
  final String message;

  BankTransferModel({
    required this.status,
    required this.transactionCode,
    required this.message,
  });

  factory BankTransferModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') ? json['data'] : json;
    return BankTransferModel(
      status: data['status'],
      transactionCode:data['transaction_code'],
      message: data['message'],
    );
  }

  @override
  String toString() => 'BankTransfer($message: $transactionCode - $status)';
}