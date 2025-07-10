import 'package:flutter/material.dart';
import 'package:jasara_poc/widgets/utils/app_palette.dart';
import 'package:jasara_poc/widgets/utils/app_textStyles.dart';
import 'package:provider/provider.dart';

import 'providers/app_state_provider.dart';
import 'views/admin/control_panel_page.dart';
import 'views/user/home_page.dart';
import 'widgets/utils/app_button.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final isUser = appState.currentScreen == AppScreen.user;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isUser ? JasaraPalette.accent : JasaraPalette.primary,
        title: Text(
          isUser ? 'User View' : 'Admin Control Panel',
          style: JasaraTextStyles.primaryText500.copyWith(
            color: isUser ? JasaraPalette.dark1 : JasaraPalette.white,
            fontSize: 20,
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton2(
              onPressed: () {
                final newScreen = isUser ? AppScreen.admin : AppScreen.user;
                context.read<AppStateProvider>().switchScreen(newScreen);
              },
              label: '',
              backgroundColor:
                  isUser ? JasaraPalette.primary : JasaraPalette.accent,
              borderColor:
                  isUser ? JasaraPalette.primary : JasaraPalette.accent,
              customWidget: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.swap_horiz,
                    color: isUser ? JasaraPalette.white : JasaraPalette.dark1,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Switch to ${isUser ? 'Admin' : 'User'}',
                    style: TextStyle(
                      color: isUser ? JasaraPalette.white : JasaraPalette.dark2,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: isUser ? const HomePage() : const ControlPanelPage(),
    );
  }
}
