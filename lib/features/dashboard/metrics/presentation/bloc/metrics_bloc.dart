import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydroponics_app/features/dashboard/metrics/domain/entities/metrics.dart';
import 'package:hydroponics_app/features/dashboard/metrics/domain/usecases/fetch_metrics.dart';

part 'metrics_event.dart';
part 'metrics_state.dart';

class MetricsBloc extends Bloc<MetricsEvent, MetricsState> {
  final FetchMetrics _fetchMetrics;

  MetricsBloc({required FetchMetrics fetchMetrics})
      : _fetchMetrics = fetchMetrics,
        super(MetricsInitial()) {
    on<MetricsFetchMetrics>((event, emit) async {
      final Map<String, List<Metrics>> combinedData = {};

      emit(MetricsLoading());

      try {
        final fetchTasks = event.tables.map((table) async {
          final result = await _fetchMetrics(FetchMetricsParams(table: table));

          result.fold(
            (failure) {
              emit(MetricsFailure(failure.message));
            },
            (metricsStream) async {
              await for (final logs in metricsStream) {
                combinedData[table] = logs;
              }
            },
          );
        }).toList();

        await Future.wait(fetchTasks);

        emit(MetricsDisplaySuccess(combinedData));
      } catch (e) {
        emit(MetricsFailure("Unexpected error: $e"));
      }
    });
  }
}
