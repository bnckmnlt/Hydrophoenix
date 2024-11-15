import 'package:fpdart/fpdart.dart';
import 'package:hydroponics_app/core/error/failures.dart';
import 'package:hydroponics_app/core/usecase/usecase.dart';
import 'package:hydroponics_app/features/dashboard/logs/domain/entities/logs.dart';
import 'package:hydroponics_app/features/dashboard/logs/domain/repository/logs_repository.dart';

class FetchLogs implements UseCase<Stream<List<Logs>>, NoParams> {
  final LogsRepository logsRepository;

  const FetchLogs(this.logsRepository);

  @override
  Future<Either<Failure, Stream<List<Logs>>>> call(NoParams params) async {
    return await logsRepository.fetchAllLogs();
  }
}
