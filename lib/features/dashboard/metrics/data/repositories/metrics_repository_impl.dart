import 'package:fpdart/fpdart.dart';
import 'package:hydroponics_app/core/error/exceptions.dart';
import 'package:hydroponics_app/core/error/failures.dart';
import 'package:hydroponics_app/features/dashboard/metrics/data/datasources/metrics_remote_data_source.dart';
import 'package:hydroponics_app/features/dashboard/metrics/domain/entities/metrics.dart';
import 'package:hydroponics_app/features/dashboard/metrics/domain/repository/metrics_repository.dart';

class MetricsRepositoryImpl implements MetricsRepository {
  final MetricsRemoteDataSource remoteDataSource;

  const MetricsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Stream<List<Metrics>>>> fetchMetrics({
    required String table,
  }) async {
    try {
      final metricsData = remoteDataSource.fetchMetrics(table: table);

      return right(metricsData);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
