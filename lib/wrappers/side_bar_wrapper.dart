// widgets/sidebar.dart
import 'package:flutter/material.dart';
import 'package:jasara_poc/widgets/utils/app_palette.dart';
import 'package:jasara_poc/widgets/utils/app_textStyles.dart';

import '../models/sidebarItemModel.dart';

class Sidebar extends StatelessWidget {
  final bool isCollapsed;
  final VoidCallback toggleCollapse;
  final List<SidebarItemModel> items;
  final VoidCallback onRoleSwitch;
  final bool isUser;

  const Sidebar({
    super.key,
    required this.isCollapsed,
    required this.toggleCollapse,
    required this.items,
    required this.onRoleSwitch,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isCollapsed ? 70 : 220,
      decoration: BoxDecoration(
        color: JasaraPalette.primary,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(60),
          // bottomRight: Radius.circular(60),
        ),
      ),
      child: Column(
        children: [
          /// Logo/Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                isCollapsed
                    ? Image.asset('assets/images/logo_icon.png', height: 30)
                    : Row(
                      children: [
                        Image.asset('assets/images/logo_icon.png', height: 30),
                        const SizedBox(width: 8),
                        Text(
                          'Jasara',
                          style: JasaraTextStyles.primaryText500.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
          ),

          const Spacer(),

          ...items.map(
            (item) => Container(
              padding: const EdgeInsets.all(12),
              decoration:
                  item.isSelected
                      ? BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(50),
                        ),
                      )
                      : null,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                leading: Icon(
                  item.icon,
                  color: item.isSelected ? Colors.black : Colors.white,
                ),
                title:
                    isCollapsed
                        ? null
                        : Text(
                          item.label,
                          style: JasaraTextStyles.primaryText500.copyWith(
                            color:
                                item.isSelected
                                    ? JasaraPalette.dark1
                                    : JasaraPalette.background,
                            fontSize: 20,
                          ),
                        ),
                onTap: item.onTap,
              ),
            ),
          ),

          const Spacer(),

          /// Role Switch
          ListTile(
            leading: const Icon(Icons.swap_horiz, color: Colors.white),
            title:
                isCollapsed
                    ? null
                    : Text(
                      'Switch to ${isUser ? 'Admin' : 'User'}',
                      style: JasaraTextStyles.primaryText500.copyWith(
                        color: JasaraPalette.background,
                      ),
                    ),
            onTap: onRoleSwitch,
          ),

          /// Collapse Toggle
          IconButton(
            icon: Icon(
              isCollapsed
                  ? Icons.keyboard_arrow_right
                  : Icons.keyboard_arrow_left,
              color: Colors.white,
            ),
            onPressed: toggleCollapse,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
