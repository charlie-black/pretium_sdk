class PretiumException implements Exception {
  final int code;
  final String message;

  PretiumException({
    required this.code,
    required this.message,
  });

  @override
  String toString() => 'PretiumException($code): $message';
}