// models/sidebar_item_model.dart
import 'package:flutter/material.dart';

class SidebarItemModel {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  SidebarItemModel({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });
}
