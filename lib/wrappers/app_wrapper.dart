import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state_provider.dart';
import '../views/criterias/criterias_list.dart';
import '../views/rfis/rfi_list.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final isRfi = appState.currentScreen == AppScreen.rfi;
    return Scaffold(
      // Earlier App bar, which i have commented out now, i am shifting it to the dashboard wrapper section.
      // appBar: buildRoleBasedAppBar(context, isUser),
      body: isRfi ? RFIListPage() : const CriteriasList(),
    );
  }
}
