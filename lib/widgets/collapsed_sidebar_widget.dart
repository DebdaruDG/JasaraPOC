import 'package:flutter/material.dart';

import 'utils/app_palette.dart';

class CollapsedSidebarItem extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool isSelected;

  const CollapsedSidebarItem({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: isSelected ? Colors.grey.shade100 : Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            child: Icon(
              icon,
              color:
                  isSelected ? Colors.black : JasaraPalette.scaffoldBackground,
            ),
          ),
        ),
      ),
    );
  }
}
