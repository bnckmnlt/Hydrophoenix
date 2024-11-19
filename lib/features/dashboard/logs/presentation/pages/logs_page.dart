// Assuming `log.severity` is of type `LogSeverity`, let's update the filter logic

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydroponics_app/core/common/loader.dart';
import 'package:hydroponics_app/core/utils/error_display.dart';
import 'package:hydroponics_app/core/utils/show_snackbar.dart';
import 'package:hydroponics_app/features/dashboard/logs/domain/entities/logs.dart';
import 'package:hydroponics_app/features/dashboard/logs/presentation/bloc/logs_bloc.dart';
import 'package:hydroponics_app/features/dashboard/logs/presentation/widgets/LogTile.dart';

enum LogSeverityFilter { all, log, error, warning }

class LogsPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const LogsPage());

  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  bool isChartShown = false;
  String searchQuery = '';
  LogSeverityFilter selectedSeverity = LogSeverityFilter.all;

  @override
  void initState() {
    super.initState();
    context.read<LogsBloc>().add(LogsFetchLogs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<LogsBloc, LogsState>(
          builder: (context, state) {
            if (state is LogsLoading) {
              return const Loader();
            } else if (state is LogsDisplaySuccess) {
              var logs = state.logs;

              if (searchQuery.isNotEmpty) {
                logs = logs
                    .where((log) => log.message
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                    .toList();
              }

              if (selectedSeverity != LogSeverityFilter.all) {
                logs = logs.where((log) {
                  switch (selectedSeverity) {
                    case LogSeverityFilter.log:
                      return log.severity == LogSeverity.log;
                    case LogSeverityFilter.error:
                      return log.severity == LogSeverity.error;
                    case LogSeverityFilter.warning:
                      return log.severity == LogSeverity.warning;
                    default:
                      return true;
                  }
                }).toList();
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: CupertinoSearchTextField(
                            placeholder: "Search events",
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 8.0),
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          child: CupertinoButton(
                            padding: const EdgeInsets.symmetric(
                                vertical: 1.0, horizontal: 1.5),
                            child: const Icon(CupertinoIcons.refresh),
                            onPressed: () {
                              context.read<LogsBloc>().add(LogsFetchLogs());
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        PopupMenuButton<LogSeverityFilter>(
                          onSelected: (value) {
                            setState(() {
                              selectedSeverity = value;
                            });
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: LogSeverityFilter.all,
                              child: Text('All'),
                            ),
                            PopupMenuItem(
                              value: LogSeverityFilter.log,
                              child: Text('Log'),
                            ),
                            PopupMenuItem(
                              value: LogSeverityFilter.error,
                              child: Text('Error'),
                            ),
                            PopupMenuItem(
                              value: LogSeverityFilter.warning,
                              child: Text('Warning'),
                            ),
                          ],
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 12.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            child: Text(
                              selectedSeverity == LogSeverityFilter.all
                                  ? "All"
                                  : selectedSeverity
                                      .toString()
                                      .split('.')
                                      .last, // Display selected severity
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.025,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isChartShown = !isChartShown;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 12.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            child: Row(
                              children: [
                                isChartShown
                                    ? const Icon(CupertinoIcons.eye)
                                    : const Icon(CupertinoIcons.eye_slash),
                                const SizedBox(width: 12),
                                const Text(
                                  "Chart",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.025,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isChartShown) const SizedBox(height: 174),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                            width: 1,
                          ),
                        ),
                      ),
                      child: logs.isNotEmpty
                          ? ListView(
                              children: logs
                                  .map((log) => LogTile(
                                        id: log.id,
                                        severity: log.severity,
                                        message: log.message,
                                        createdAt:
                                            log.createdAt.toIso8601String(),
                                      ))
                                  .toList(),
                            )
                          : const ErrorDisplay(
                              errorMessage: "No data to display"),
                    ),
                  ),
                ],
              );
            } else if (state is LogsFailure) {
              context.showSnackBar(message: state.message);
              return const ErrorDisplay(errorMessage: "Failed to load logs");
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
