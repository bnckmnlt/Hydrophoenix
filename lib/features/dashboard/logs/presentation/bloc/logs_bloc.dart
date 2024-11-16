import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydroponics_app/core/usecase/usecase.dart';
import 'package:hydroponics_app/features/dashboard/logs/domain/entities/logs.dart';
import 'package:hydroponics_app/features/dashboard/logs/domain/usecases/fetch_logs.dart';

part 'logs_event.dart';
part 'logs_state.dart';

class LogsBloc extends Bloc<LogsEvent, LogsState> {
  final FetchLogs _fetchLogs;

  LogsBloc({
    required FetchLogs fetchLogs,
  })  : _fetchLogs = fetchLogs,
        super(LogsInitial()) {
    on<LogsFetchLogs>((event, emit) async {
      final res = await _fetchLogs(NoParams());

      res.fold(
        (failure) => emit(LogsFailure(failure.message)),
        (logsStream) async {
          try {
            await emit.forEach<List<Logs>>(
              logsStream,
              onData: (logs) => LogsDisplaySuccess(logs),
              onError: (error, stackTrace) => LogsFailure(error.toString()),
            );
          } catch (error, stackTrace) {
            emit(LogsFailure('Unexpected error: $error'));
          }
        },
      );
    });
  }
}
