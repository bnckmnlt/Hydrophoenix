import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class NavigationMenu extends StatelessWidget {
  final int currentPage;
  final ValueChanged<int> onPageSelected;

  const NavigationMenu({
    super.key,
    required this.currentPage,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentPage,
      onDestinationSelected: (int index) {
        onPageSelected(index);
      },
      height: 80,
      elevation: 0,
      backgroundColor: Colors.transparent,
      destinations: const [
        NavigationDestination(
          icon: Icon(FluentIcons.home_24_regular),
          label: "Home",
          tooltip: "Home",
        ),
        NavigationDestination(
          icon: Icon(FluentIcons.data_usage_24_regular),
          label: "Metrics",
          tooltip: "Metrics",
        ),
        NavigationDestination(
          icon: Icon(FluentIcons.book_pulse_24_regular),
          label: "Logs",
          tooltip: "Logs",
        ),
        NavigationDestination(
          icon: Icon(FluentIcons.options_24_regular),
          label: "Setup",
          tooltip: "Setup",
        ),
      ],
    );
  }
}
