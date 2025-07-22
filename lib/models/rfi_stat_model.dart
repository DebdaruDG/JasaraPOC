import 'package:flutter/material.dart';

class StatModel {
  final String label;
  final String value;
  final IconData icon;
  final List<Color> gradientColors;

  StatModel({
    required this.label,
    required this.value,
    required this.icon,
    required this.gradientColors,
  });
}
