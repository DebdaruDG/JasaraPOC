import 'package:flutter/material.dart';
import '../../providers/app_state_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/utils/app_palette.dart';
import '../widgets/utils/app_textStyles.dart';

class DashboardAppBar extends StatelessWidget {
  const DashboardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final isRfi = appState.currentScreen == AppScreen.rfi;

    return Container(
      height: 100,
      color: JasaraPalette.scaffoldBackground,
      child: Container(
        margin: const EdgeInsets.only(left: 40, right: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isRfi ? 'RFI' : 'Criteria',
              style: JasaraTextStyles.primaryText500.copyWith(
                fontSize: 38,
                color: JasaraPalette.dark1,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.135,
              child: TextField(
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.search),
                  hintText: 'Search something here...',
                  hintStyle: JasaraTextStyles.primaryText400.copyWith(
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: JasaraPalette.grey.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
