import 'package:hydroponics_app/core/error/exceptions.dart';
import 'package:hydroponics_app/features/dashboard/logs/data/models/logs_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class LogsRemoteDataSource {
  Stream<List<LogsModel>> fetchLogs();
}

class LogsRemoteDataSourceImpl implements LogsRemoteDataSource {
  final SupabaseClient supabase;

  LogsRemoteDataSourceImpl(this.supabase);

  @override
  Stream<List<LogsModel>> fetchLogs() {
    try {
      final logsStream = supabase.from('event').stream(primaryKey: ['id']);

      return logsStream.map<List<LogsModel>>((logList) {
        final logs =
            logList.map<LogsModel>((log) => LogsModel.fromJson(log)).toList();

        logs.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        return logs;
      });
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
