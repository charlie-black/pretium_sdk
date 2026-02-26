class TransactionItem {
  final int id;
  final String transactionCode;
  final String? receiptNumber;
  final String amount;
  final String amountInUsd;
  final String shortcode;
  final String? publicName;
  final String currencyCode;
  final String message;
  final String type;
  final String category;
  final String status;
  final String chain;
  final String? asset;
  final String? transactionHash;
  final String mobileNetwork;
  final bool isReleased;
  final DateTime createdAt;

  TransactionItem({
    required this.id,
    required this.transactionCode,
    this.receiptNumber,
    required this.amount,
    required this.amountInUsd,
    required this.shortcode,
    this.publicName,
    required this.currencyCode,
    required this.message,
    required this.type,
    required this.category,
    required this.status,
    required this.chain,
    this.asset,
    this.transactionHash,
    required this.mobileNetwork,
    required this.isReleased,
    required this.createdAt,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      id: json['id'],
      transactionCode: json['transaction_code'],
      receiptNumber: json['receipt_number'],
      amount: json['amount'],
      amountInUsd: json['amount_in_usd'],
      shortcode: json['shortcode'],
      publicName: json['public_name'],
      currencyCode: json['currency_code'],
      message: json['message'],
      type: json['type'],
      category: json['category'],
      status: json['status'],
      chain: json['chain'],
      asset: json['asset'],
      transactionHash: json['transaction_hash'],
      mobileNetwork: json['mobile_network'],
      isReleased: json['is_released'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Convenience getters
  bool get isComplete => status == 'COMPLETE';
  bool get isFailed => status == 'FAILED';
  bool get isPending => status == 'PENDING';
  bool get isDisbursement => category == 'DISBURSEMENT';
  bool get isCollection => category == 'COLLECTION';

  @override
  String toString() =>
      'TransactionItem(id: $id, code: $transactionCode, amount: $amount $currencyCode, status: $status)';
}

class AllTransactionsModel {
  final List<TransactionItem> transactions;

  AllTransactionsModel({required this.transactions});

  factory AllTransactionsModel.fromJson(Map<String, dynamic> json) {
    return AllTransactionsModel(
      transactions: (json['data'] as List)
          .map((t) => TransactionItem.fromJson(t))
          .toList(),
    );
  }

  // Convenience getters
  List<TransactionItem> get completed =>
      transactions.where((t) => t.isComplete).toList();

  List<TransactionItem> get failed =>
      transactions.where((t) => t.isFailed).toList();

  List<TransactionItem> get pending =>
      transactions.where((t) => t.isPending).toList();

  List<TransactionItem> get disbursements =>
      transactions.where((t) => t.isDisbursement).toList();

  List<TransactionItem> get collections =>
      transactions.where((t) => t.isCollection).toList();

  @override
  String toString() =>
      'AllTransactionsModel(total: ${transactions.length}, completed: ${completed.length}, failed: ${failed.length}, pending: ${pending.length})';
}


