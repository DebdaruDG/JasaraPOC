import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state_provider.dart';
import '../widgets/utils/app_palette.dart';
import '../widgets/utils/app_textStyles.dart';
import '../widgets/utils/app_button.dart'; // Assuming CustomButton2 is defined here

AppBar buildRoleBasedAppBar(BuildContext context, bool isUser) {
  return AppBar(
    backgroundColor: isUser ? JasaraPalette.accent : JasaraPalette.primary,
    title: Text(
      isUser ? 'User View' : 'Admin Control Panel',
      style: JasaraTextStyles.primaryText500.copyWith(
        color: isUser ? JasaraPalette.dark1 : JasaraPalette.white,
        fontSize: 20,
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomButton2(
          onPressed: () {
            final newScreen = isUser ? AppScreen.admin : AppScreen.user;
            context.read<AppStateProvider>().switchScreen(newScreen);
          },
          label: '',
          backgroundColor:
              isUser ? JasaraPalette.primary : JasaraPalette.accent,
          borderColor: isUser ? JasaraPalette.primary : JasaraPalette.accent,
          customWidget: Row(
            mainAxisSize: MainAxisSize.min,
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
  );
}
