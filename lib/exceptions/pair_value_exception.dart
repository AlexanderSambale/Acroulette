class PairValueException implements Exception {
  final dynamic message;

  PairValueException([this.message]);

  @override
  String toString() {
    Object? message = this.message;
    if (message == null) return "PairValueException";
    return "PairValueException: $message";
  }
}
