import 'package:fpdart/fpdart.dart';
import 'package:hydroponics_app/core/error/failures.dart';
import 'package:hydroponics_app/features/dashboard/logs/domain/entities/logs.dart';

abstract interface class LogsRepository {
  Future<Either<Failure, Stream<List<Logs>>>> fetchAllLogs();
}
