part of 'logs_bloc.dart';

@immutable
sealed class LogsEvent {}

final class LogsFetchLogs extends LogsEvent {}