import 'package:flutter/material.dart';
import '../widgets/utils/app_palette.dart';
import '../widgets/utils/app_textStyles.dart';

class ControlPanelPage extends StatelessWidget {
  const ControlPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Admin Control Panel",
                style: JasaraTextStyles.primaryText500.copyWith(
                  fontSize: 22,
                  color: JasaraPalette.dark2,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Add Criteria",
                    style: JasaraTextStyles.primaryText500.copyWith(
                      fontSize: 22,
                      color: JasaraPalette.dark2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
