part of 'logs_bloc.dart';

@immutable
sealed class LogsState {
  const LogsState();
}

final class LogsInitial extends LogsState {}

final class LogsLoading extends LogsState {}

final class LogsDisplaySuccess extends LogsState {
  final List<Logs> logs;

  const LogsDisplaySuccess(this.logs);
}

final class LogsFailure extends LogsState {
  final String message;

  const LogsFailure(this.message);
}
