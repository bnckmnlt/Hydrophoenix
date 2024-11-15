import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hydroponics_app/core/app_secrets.dart';
import 'package:hydroponics_app/core/network/connection_checker.dart';
import 'package:hydroponics_app/features/dashboard/logs/data/datasources/logs_remote_data_source.dart';
import 'package:hydroponics_app/features/dashboard/logs/data/repositories/logs_repository_impl.dart';
import 'package:hydroponics_app/features/dashboard/logs/domain/repository/logs_repository.dart';
import 'package:hydroponics_app/features/dashboard/logs/domain/usecases/fetch_logs.dart';
import 'package:hydroponics_app/features/dashboard/logs/presentation/bloc/logs_bloc.dart';
import 'package:hydroponics_app/mqtt_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initLogs();

  await dotenv.load(fileName: ".env");

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.anonKey,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerLazySingleton(() => MqttService());

  await serviceLocator<MqttService>().connect();

  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );
}

void _initLogs() {
  serviceLocator
    ..registerFactory<LogsRemoteDataSource>(
      () => LogsRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<LogsRepository>(
      () => LogsRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => FetchLogs(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => LogsBloc(
        fetchLogs: serviceLocator(),
      ),
    );
}
