import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/add_rfi_provider.dart';
import 'providers/app_state_provider.dart';
import 'providers/assessment_page_provider.dart';
import 'providers/assessment_provider.dart';
import 'app.dart';
import 'providers/criteria_provider.dart';
import 'providers/screen_switch_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 🛠 Needed before async ops
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ChangeNotifierProvider(create: (_) => AssessmentProvider()),
        ChangeNotifierProvider(create: (_) => AssessmentPageProvider()),
        ChangeNotifierProvider(create: (_) => CriteriaProvider()),
        ChangeNotifierProvider(create: (_) => AssessmentProvider()),
        ChangeNotifierProvider(create: (_) => HomePageProvider()),
        ChangeNotifierProvider(create: (_) => ScreenSwitchProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
