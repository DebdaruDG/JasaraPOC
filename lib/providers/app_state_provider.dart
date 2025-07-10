import 'package:flutter/material.dart';

enum AppScreen { user, admin }

class AppStateProvider extends ChangeNotifier {
  AppScreen _currentScreen = AppScreen.user;

  AppScreen get currentScreen => _currentScreen;

  void switchScreen(AppScreen screen) {
    _currentScreen = screen;
    notifyListeners();
  }
}
