import 'package:flutter/material.dart';
import 'package:hydroponics_app/features/dashboard/NavigationMenu.dart';
import 'package:hydroponics_app/features/dashboard/home/presentation/pages/home.dart';
import 'package:hydroponics_app/features/dashboard/logs/presentation/pages/logs_page.dart';
import 'package:hydroponics_app/features/dashboard/metrics/presentation/pages/metrics_page.dart';
import 'package:hydroponics_app/features/dashboard/setup/presentation/pages/setup_page.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  final List<Widget> pages = [
    const HomePage(),
    const MetricsPage(),
    const LogsPage(),
    const SetupPage(),
  ];

  int currentPage = 0;

  void _onPageSelected(int index) {
    setState(() {
      currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        leading: GestureDetector(
          child: Container(
            margin: const EdgeInsets.only(left: 16, top: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  blurRadius: 2,
                  color:
                      Theme.of(context).colorScheme.surfaceDim.withOpacity(0.3),
                )
              ],
            ),
            child: SizedBox(
              height: 48,
              child: ClipOval(
                child: Image.network('https://avatar.iran.liara.run/public'),
              ),
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(top: 12, right: 8),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none_rounded,
                size: 32,
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: NavigationMenu(
        currentPage: currentPage,
        onPageSelected: _onPageSelected,
      ),
      body: pages[currentPage],
    );
  }
}
