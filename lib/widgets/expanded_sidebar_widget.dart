import 'package:flutter/material.dart';

import 'utils/app_palette.dart';
import 'utils/app_textStyles.dart';

class ExpandedSidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isRfiSelected;
  final bool isCriteriaSelected;

  const ExpandedSidebarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isSelected,
    required this.isRfiSelected,
    required this.isCriteriaSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(left: 12),
      decoration:
          isSelected
              ? BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                  bottomLeft: Radius.circular(100),
                  bottomRight:
                      label == 'CRITERIA' && isRfiSelected
                          ? Radius.circular(80)
                          : Radius.zero,
                  topRight:
                      label == 'RFI' && isCriteriaSelected
                          ? Radius.circular(80)
                          : Radius.zero,
                ),
              )
              : null,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Icon(
          icon,
          color: isSelected ? Colors.black : JasaraPalette.scaffoldBackground,
        ),
        title: Text(
          label,
          style: JasaraTextStyles.primaryText500.copyWith(
            color:
                isSelected
                    ? JasaraPalette.dark1
                    : JasaraPalette.scaffoldBackground,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
