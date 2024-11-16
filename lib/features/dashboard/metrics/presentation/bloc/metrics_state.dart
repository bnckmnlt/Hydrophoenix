part of 'metrics_bloc.dart';

@immutable
sealed class MetricsState {
  const MetricsState();
}

final class MetricsInitial extends MetricsState {}

final class MetricsLoading extends MetricsState {}

final class MetricsDisplaySuccess extends MetricsState {
  final Map<String, List<Metrics>> combinedMetrics;

  const MetricsDisplaySuccess(this.combinedMetrics);
}

final class MetricsFailure extends MetricsState {
  final String message;

  const MetricsFailure(this.message);
}
