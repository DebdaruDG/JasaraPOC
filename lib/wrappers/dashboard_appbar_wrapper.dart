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
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: JasaraPalette.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isRfi ? 'RFI' : 'Criterias',
            style: JasaraTextStyles.primaryText500.copyWith(
              fontSize: 28,
              color: JasaraPalette.dark1,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            width: 300,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search something here...',
                filled: true,
                fillColor: JasaraPalette.charcoalGrey.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
