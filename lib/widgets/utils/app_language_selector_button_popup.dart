// language_selector_button.dart
import 'package:flutter/material.dart';

import 'app_palette.dart';

class LanguageSelectorButton extends StatelessWidget {
  final Function(String) onLanguageSelected;

  const LanguageSelectorButton({super.key, required this.onLanguageSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: "Select Language",
      position: PopupMenuPosition.under,
      color: JasaraPalette.scaffoldBackground,
      offset: const Offset(0, 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      icon: ClipOval(
        child: SizedBox(
          width: 36,
          height: 36,
          child: Image.asset(
            'assets/images/flags/english_language.jpeg',
            fit: BoxFit.cover,
          ),
        ),
      ),
      onSelected: onLanguageSelected,
      itemBuilder:
          (context) => [
            PopupMenuItem(
              value: 'en',
              child: Row(
                children: [
                  ClipOval(
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: Image.asset(
                        'assets/images/flags/english_language.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
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
                  ClipOval(
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: Image.asset(
                        'assets/images/flags/arabic_language_flag.png',
                        fit: BoxFit.cover,
                      ),
                    ),
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
