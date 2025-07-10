import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_state_provider.dart';
import 'views/assessment_page.dart';
import 'views/control_panel_page.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final isUser = appState.currentScreen == AppScreen.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(isUser ? 'User View' : 'Admin Control Panel'),
        actions: [
          TextButton.icon(
            onPressed: () {
              final newScreen = isUser ? AppScreen.admin : AppScreen.user;
              context.read<AppStateProvider>().switchScreen(newScreen);
            },
            icon: const Icon(Icons.swap_horiz),
            label: Text(isUser ? 'Switch to Admin' : 'Switch to User'),
          ),
        ],
      ),
      body: isUser ? const AssessmentPage() : const ControlPanelPage(),
    );
  }
}
