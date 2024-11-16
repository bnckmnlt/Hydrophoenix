import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydroponics_app/core/theme/theme.dart';
import 'package:hydroponics_app/features/dashboard/layout_page.dart';
import 'package:hydroponics_app/features/dashboard/logs/presentation/bloc/logs_bloc.dart';
import 'package:hydroponics_app/features/dashboard/metrics/presentation/bloc/metrics_bloc.dart';
import 'package:hydroponics_app/init_dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => serviceLocator<LogsBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<MetricsBloc>(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HydroPhoenix',
      theme: AppTheme.lightThemeMode(),
      darkTheme: AppTheme.darkThemeMode(),
      home: const LayoutPage(),
    );
  }
}
