// language_selector_button.dart
import 'package:flutter/material.dart';

class LanguageSelectorButton extends StatelessWidget {
  final Function(String) onLanguageSelected;

  const LanguageSelectorButton({super.key, required this.onLanguageSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: "Select Language",
      position: PopupMenuPosition.under,
      offset: const Offset(0, 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      icon: const CircleAvatar(
        radius: 18,
        backgroundImage: AssetImage('assets/flags/uk.png'), // 🇬🇧
      ),
      onSelected: onLanguageSelected,
      itemBuilder:
          (context) => [
            PopupMenuItem(
              value: 'en',
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 10,
                    backgroundImage: AssetImage('assets/flags/uk.png'),
                  ),
                  const SizedBox(width: 8),
                  const Text("English"),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'ar',
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 10,
                    backgroundImage: AssetImage('assets/flags/arabic.png'),
                  ),
                  const SizedBox(width: 8),
                  const Text("Arabic"),
                ],
              ),
            ),
          ],
    );
  }
}
