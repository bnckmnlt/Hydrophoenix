import 'package:hydroponics_app/features/dashboard/metrics/domain/entities/metrics.dart';

class MetricsModel extends Metrics {
  MetricsModel({
    required super.id,
    required super.value,
    required super.createdAt,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id.toInt(),
      'value': value,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MetricsModel.fromJson(Map<String, dynamic> map) {
    return MetricsModel(
      id: map['id'] as int,
      value: (map['value'] is int)
          ? (map['value'] as int).toDouble()
          : map['value'] as double,
      createdAt: map['created_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['created_at']),
    );
  }
}
