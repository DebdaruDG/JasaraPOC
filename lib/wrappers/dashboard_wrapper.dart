import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../widgets/utils/app_palette.dart';
import '../widgets/utils/app_textStyles.dart';
import 'app_wrapper.dart';
import 'dashboard_appbar_wrapper.dart';

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
    final isUser = appState.currentScreen == AppScreen.user;

    return Scaffold(
      body: Row(
        children: [
          /// Sidebar Section
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isSidebarCollapsed ? 70 : 220,
            color: JasaraPalette.primary,
            child: Column(
              children: [
                /// Sidebar Header / Logo
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:
                      isSidebarCollapsed
                          ? const Icon(Icons.dashboard, color: Colors.white)
                          : Row(
                            children: [
                              const Icon(Icons.dashboard, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                'Jasara',
                                style: JasaraTextStyles.primaryText500.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                ),

                /// Navigation Items
                ListTile(
                  leading: const Icon(Icons.checklist, color: Colors.white),
                  title:
                      isSidebarCollapsed
                          ? null
                          : const Text(
                            'Criteria',
                            style: TextStyle(color: Colors.white),
                          ),
                  onTap: () {
                    // Handle Criteria tap
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.article, color: Colors.white),
                  title:
                      isSidebarCollapsed
                          ? null
                          : const Text(
                            'RFI',
                            style: TextStyle(color: Colors.white),
                          ),
                  onTap: () {
                    // Handle RFI tap
                  },
                ),

                const Spacer(),

                /// Toggle Role Switch (Admin/User)
                ListTile(
                  leading: const Icon(Icons.swap_horiz, color: Colors.white),
                  title:
                      isSidebarCollapsed
                          ? null
                          : Text(
                            'Switch to ${isUser ? 'Admin' : 'User'}',
                            style: const TextStyle(color: Colors.white),
                          ),
                  onTap: () {
                    final newScreen = isUser ? AppScreen.admin : AppScreen.user;
                    context.read<AppStateProvider>().switchScreen(newScreen);
                  },
                ),

                /// Sidebar Collapse/Expand Toggle
                IconButton(
                  icon: Icon(
                    isSidebarCollapsed
                        ? Icons.keyboard_arrow_right
                        : Icons.keyboard_arrow_left,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isSidebarCollapsed = !isSidebarCollapsed;
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          /// Main Body Section
          Expanded(
            child: Column(
              children: [
                /// Top Bar
                DashboardAppBar(),

                /// Dynamic Content (Body)
                const Expanded(child: AppWrapper()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
