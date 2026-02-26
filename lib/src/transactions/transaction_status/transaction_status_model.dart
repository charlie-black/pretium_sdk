class TransactionStatusModel {
  final int? id;
  final String? transactionCode;
  final String? status;
  final String? amount;
  final String? amountInUsd;
  final String? type;
  final String? shortcode;
  final String? accountNumber;
  final String? publicName;
  final String? receiptNumber;
  final String? category;
  final String? chain;
  final String? asset;
  final String? transactionHash;
  final String? message;
  final String? currencyCode;
  final bool? isReleased;
  final DateTime? createdAt;

  TransactionStatusModel({
    this.id,
    this.transactionCode,
    this.status,
    this.amount,
    this.amountInUsd,
    this.type,
    this.shortcode,
    this.accountNumber,
    this.publicName,
    this.receiptNumber,
    this.category,
    this.chain,
    this.asset,
    this.transactionHash,
    this.message,
    this.currencyCode,
    this.isReleased,
    this.createdAt,
  });

  factory TransactionStatusModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return TransactionStatusModel(
      id: data['id'],
      transactionCode: data['transaction_code'],
      status: data['status'],
      amount: data['amount'],
      amountInUsd: data['amount_in_usd'],
      type: data['type'],
      shortcode: data['shortcode'],
      accountNumber: data['account_number'],
      publicName: data['public_name'],
      receiptNumber: data['receipt_number'],
      category: data['category'],
      chain: data['chain'],
      asset: data['asset'],
      transactionHash: data['transaction_hash'],
      message: data['message'],
      currencyCode: data['currency_code'],
      isReleased: data['is_released'],
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : null,
    );
  }

  // Convenience getters
  bool get isComplete => status == 'COMPLETE';
  bool get isFailed => status == 'FAILED';
  bool get isPending => status == 'PENDING';

  @override
  String toString() =>
      'TransactionStatusModel(id: $id, code: $transactionCode, status: $status, amount: $amount $currencyCode)';
}