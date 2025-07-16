import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jasara_poc/widgets/utils/app_palette.dart';
import 'package:jasara_poc/widgets/utils/app_textStyles.dart';

import '../models/sidebarItemModel.dart';
import '../widgets/profile_tile.dart';

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
      width: isCollapsed ? 70 : 300,
      decoration: BoxDecoration(
        color: JasaraPalette.indigoBlue,
        borderRadius: const BorderRadius.only(topRight: Radius.circular(80)),
      ),
      child: Column(
        children: [
          /// Logo/Header
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: MediaQuery.of(context).size.height * 0.1125,
            ),
            child:
                isCollapsed
                    ? jasaraIconSVGLogo(45)
                    : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [jasaraSVGLogo(45)],
                    ),
          ),

          const Spacer(flex: 1),

          ...items.map(
            (item) => Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(left: 12),
              decoration:
                  item.isSelected
                      ? BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(100), // outer top-left curve
                          bottomLeft: Radius.circular(100),
                          topRight: Radius.circular(0), // inner corner
                          bottomRight: Radius.circular(0), // inner corner
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                onTap: item.onTap,
              ),
            ),
          ),

          const Spacer(flex: 2),

          /// Role Switch
          Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: JasaraPalette.teal,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: ListTile(
              leading: const Icon(Icons.swap_horiz, color: Colors.white),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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
          ),

          ProfileTile(
            name: 'F. Sullivan',
            title: '@Frankie',
            imageUrl:
                'assets/images/download.jpeg', // replace with real URL or Asset
            isCollapsed: false,
            onTap: () => print('Profile clicked'),
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

  Widget jasaraSVGLogo(double height) => SvgPicture.asset(
    'assets/logos/logo.svg',
    height: height,
    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
  );
  Widget jasaraIconSVGLogo(double height) => SvgPicture.asset(
    'assets/logos/jasara_small_icon.svg',
    height: height,
    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
  );
}
