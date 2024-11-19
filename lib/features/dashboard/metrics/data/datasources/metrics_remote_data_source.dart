import 'package:hydroponics_app/core/error/exceptions.dart';
import 'package:hydroponics_app/features/dashboard/metrics/data/models/metrics_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class MetricsRemoteDataSource {
  Stream<List<MetricsModel>> fetchMetrics({
    required String table,
  });
}

class MetricsRemoteDataSourceImpl implements MetricsRemoteDataSource {
  final SupabaseClient supabaseClient;

  const MetricsRemoteDataSourceImpl(this.supabaseClient);

  @override
  Stream<List<MetricsModel>> fetchMetrics({
    required String table,
  }) {
    try {
      final metricsStream = supabaseClient
          .from(table)
          .stream(primaryKey: ['id']).order('created_at', ascending: false);

      return metricsStream.map<List<MetricsModel>>((logList) {
        final metrics = logList
            .map<MetricsModel>((log) => MetricsModel.fromJson(log))
            .toList();

        return metrics;
      });
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
