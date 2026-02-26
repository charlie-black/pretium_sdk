class ValidateAccountNigeriaModel {
  final String status;
  final String accountName;
  final String accountNumber;
  final String bankName;
  final String bankCode;

  ValidateAccountNigeriaModel({
    required this.status,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
    required this.bankCode,
  });

  factory ValidateAccountNigeriaModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') ? json['data'] : json;
    return ValidateAccountNigeriaModel(
      status: data['status'],
      accountName: data['account_name'],
      accountNumber: data['account_number'],
      bankName: data['bank_name'],
      bankCode: data['bank_code']
    );
  }

  @override
  String toString() => 'ValidationData($accountNumber: $accountName - $bankName - $bankCode)';
}