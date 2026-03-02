class OnRampInitiateResponse {
  final int code;
  final String message;
  final OnRampData data;

  OnRampInitiateResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory OnRampInitiateResponse.fromJson(Map<String, dynamic> json) {
    return OnRampInitiateResponse(
      code: json['code'] as int,
      message: json['message'] as String,
      data: OnRampData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  String toString() {
    return 'OnRampInitiateResponse('
        'code: $code, '
        'message: "$message", '
        'data: $data'
        ')';
  }
}

class OnRampData {
  final String transactionCode;
  final String status;
  final String message;

  OnRampData({
    required this.transactionCode,
    required this.status,
    required this.message,
  });

  factory OnRampData.fromJson(Map<String, dynamic> json) {
    return OnRampData(
      transactionCode: json['transaction_code'] as String,
      status: json['status'] as String,
      message: json['message'] as String,
    );
  }

  @override
  String toString() => 'OnRampData(transactionCode: $transactionCode, status: $status, message: "$message")';
}