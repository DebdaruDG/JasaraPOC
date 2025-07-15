import 'package:flutter/material.dart';

enum AppScreen { rfi, criterias }

class AppStateProvider extends ChangeNotifier {
  AppScreen _currentScreen = AppScreen.rfi;

  AppScreen get currentScreen => _currentScreen;

  void switchScreen(AppScreen screen) {
    _currentScreen = screen;
    notifyListeners();
  }
}
