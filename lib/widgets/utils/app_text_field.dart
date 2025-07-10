import 'package:flutter/material.dart';
import 'app_palette.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  // final int maxLines;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    // this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      // minLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: JasaraPalette.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
