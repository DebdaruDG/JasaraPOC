// views/dashboard_wrapper.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/sidebarItemModel.dart';
import '../providers/app_state_provider.dart';
import '../widgets/utils/app_palette.dart';
import 'app_wrapper.dart';
import 'dashboard_appbar_wrapper.dart';
import 'side_bar_wrapper.dart';

class DashboardWrapper extends StatefulWidget {
  const DashboardWrapper({super.key});

  @override
  State<DashboardWrapper> createState() => _DashboardWrapperState();
}

class _DashboardWrapperState extends State<DashboardWrapper> {
  bool isSidebarCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final isRfi = appState.currentScreen == AppScreen.rfi;

    final currentScreen = appState.currentScreen;

    final sidebarItems = [
      SidebarItemModel(
        icon: Icons.home,
        label: "Criteria",
        isSelected: currentScreen == AppScreen.criterias,
        onTap: () {
          appState.switchScreen(AppScreen.criterias);
        },
      ),
      SidebarItemModel(
        icon: Icons.description,
        label: 'RFI',
        isSelected: currentScreen == AppScreen.rfi,
        onTap: () {
          appState.switchScreen(AppScreen.rfi);
        },
      ),
    ];

    return Scaffold(
      backgroundColor: JasaraPalette.scaffoldBackground,
      body: Row(
        children: [
          Sidebar(
            isCollapsed: isSidebarCollapsed,
            toggleCollapse: () {
              setState(() {
                isSidebarCollapsed = !isSidebarCollapsed;
              });
            },
            items: sidebarItems,
            isUser: isRfi,
            onRoleSwitch: () {
              final newScreen = isRfi ? AppScreen.criterias : AppScreen.rfi;
              context.read<AppStateProvider>().switchScreen(newScreen);
            },
          ),
          Expanded(
            child: Column(
              children: [
                DashboardAppBar(),
                const Expanded(child: AppWrapper()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
