import 'package:fpdart/src/either.dart';
import 'package:hydroponics_app/core/error/failures.dart';
import 'package:hydroponics_app/core/usecase/usecase.dart';
import 'package:hydroponics_app/features/dashboard/metrics/domain/entities/metrics.dart';

import '../repository/metrics_repository.dart';

class FetchMetrics
    implements UseCase<Stream<List<Metrics>>, FetchMetricsParams> {
  final MetricsRepository metricsRepository;

  const FetchMetrics(this.metricsRepository);

  @override
  Future<Either<Failure, Stream<List<Metrics>>>> call(
    FetchMetricsParams params,
  ) async {
    return await metricsRepository.fetchMetrics(
      table: params.table,
    );
  }
}

class FetchMetricsParams {
  final String table;

  FetchMetricsParams({
    required this.table,
  });
}
