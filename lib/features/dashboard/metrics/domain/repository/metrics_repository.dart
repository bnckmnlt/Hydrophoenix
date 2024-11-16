import 'package:fpdart/fpdart.dart';
import 'package:hydroponics_app/core/error/failures.dart';
import 'package:hydroponics_app/features/dashboard/metrics/domain/entities/metrics.dart';

abstract interface class MetricsRepository {
  Future<Either<Failure, Stream<List<Metrics>>>> fetchMetrics({
    required String table,
  });
}
