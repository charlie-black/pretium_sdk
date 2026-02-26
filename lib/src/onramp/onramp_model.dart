class OnRampInitiateResponse {
  final String transactionCode;
  final String status;
  final String message;

  OnRampInitiateResponse({
    required this.transactionCode,
    required this.status,
    required this.message,
  });

  factory OnRampInitiateResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    return OnRampInitiateResponse(
      transactionCode: data['transaction_code'] as String? ?? '',
      status: data['status'] as String? ?? 'UNKNOWN',
      message: data['message'] as String? ?? '',
    );
  }
}