import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state_provider.dart';
import '../widgets/utils/app_palette.dart';
import '../widgets/utils/app_textStyles.dart';
import '../widgets/utils/app_button.dart'; // Assuming CustomButton2 is defined here

AppBar buildRoleBasedAppBar(BuildContext context, bool isRfi) {
  return AppBar(
    backgroundColor: isRfi ? JasaraPalette.accent : JasaraPalette.primary,
    title: Text(
      isRfi ? 'User View' : 'Admin Control Panel',
      style: JasaraTextStyles.primaryText500.copyWith(
        color: isRfi ? JasaraPalette.dark1 : JasaraPalette.white,
        fontSize: 20,
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomButton2(
          onPressed: () {
            final newScreen = isRfi ? AppScreen.criterias : AppScreen.rfi;
            context.read<AppStateProvider>().switchScreen(newScreen);
          },
          label: '',
          backgroundColor: isRfi ? JasaraPalette.primary : JasaraPalette.accent,
          borderColor: isRfi ? JasaraPalette.primary : JasaraPalette.accent,
          customWidget: Container(
            color: JasaraPalette.teal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.swap_horiz,
                  color: isRfi ? JasaraPalette.white : JasaraPalette.dark1,
                ),
                const SizedBox(width: 8),
                Text(
                  'Switch to ${isRfi ? 'Admin' : 'User'}',
                  style: TextStyle(
                    color: isRfi ? JasaraPalette.white : JasaraPalette.dark2,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
