import 'package:flutter/material.dart';

class RFIStatModel {
  final String label;
  final String value;
  final IconData icon;
  final List<Color> gradientColors;

  RFIStatModel({
    required this.label,
    required this.value,
    required this.icon,
    required this.gradientColors,
  });
}
