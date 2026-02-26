class BankTransferNigeriaModel {
  final String status;
  final String transactionCode;
  final String message;

  BankTransferNigeriaModel({
    required this.status,
    required this.transactionCode,
    required this.message,
  });

  factory BankTransferNigeriaModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') ? json['data'] : json;
    return BankTransferNigeriaModel(
      status: data['status'],
      transactionCode:data['transaction_code'],
      message: data['message'],
    );
  }

  @override
  String toString() => 'BankTransfer($message: $transactionCode - $status)';
}