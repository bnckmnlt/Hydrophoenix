import 'package:fpdart/fpdart.dart';
import 'package:hydroponics_app/core/error/exceptions.dart';
import 'package:hydroponics_app/core/error/failures.dart';
import 'package:hydroponics_app/features/dashboard/logs/data/datasources/logs_remote_data_source.dart';
import 'package:hydroponics_app/features/dashboard/logs/domain/entities/logs.dart';
import 'package:hydroponics_app/features/dashboard/logs/domain/repository/logs_repository.dart';

class LogsRepositoryImpl implements LogsRepository {
  final LogsRemoteDataSource remoteDataSource;

  const LogsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Stream<List<Logs>>>> fetchAllLogs() async {
    try {
      final logsData = await remoteDataSource.fetchLogs();

      return right(logsData);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
