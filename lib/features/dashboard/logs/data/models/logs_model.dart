import 'package:hydroponics_app/features/dashboard/logs/domain/entities/logs.dart';

class LogsModel extends Logs {
  LogsModel({
    required super.id,
    required super.severity,
    required super.message,
    required super.createdAt,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'severity': severity.toString().split('.').last,
      'message': message,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory LogsModel.fromJson(Map<String, dynamic> map) {
    return LogsModel(
      id: map['id'] as int,
      severity: stringToLogSeverity(map['severity'] as String),
      message: map['message'] as String,
      createdAt: map['created_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['created_at']),
    );
  }
}

LogSeverity stringToLogSeverity(String severity) {
  switch (severity) {
    case 'log':
      return LogSeverity.log;
    case 'error':
      return LogSeverity.error;
    case 'warning':
      return LogSeverity.warning;
    default:
      throw ArgumentError('Invalid severity: $severity');
  }
}
