enum LogSeverity {
  log,
  error,
  warning,
}

class Logs {
  final int id;
  final LogSeverity severity;
  final String message;
  final DateTime createdAt;

  Logs({
    required this.id,
    required this.severity,
    required this.message,
    required this.createdAt,
  });
}
