part of 'metrics_bloc.dart';

@immutable
sealed class MetricsEvent {}

class MetricsFetchMetrics extends MetricsEvent {
  final List<String> tables;

  MetricsFetchMetrics({required this.tables});
}
