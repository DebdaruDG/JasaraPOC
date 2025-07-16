import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jasara_poc/widgets/utils/app_palette.dart';
import 'package:jasara_poc/widgets/utils/app_textStyles.dart';

import '../models/sidebarItemModel.dart';
import '../widgets/profile_tile.dart';

class _CollapsedSidebarItem extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool isSelected;

  const _CollapsedSidebarItem({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Material(
          color: isSelected ? Colors.grey.shade100 : Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(
                icon,
                color:
                    isSelected
                        ? Colors.black
                        : JasaraPalette.scaffoldBackground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpandedSidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  const _ExpandedSidebarItem({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isSelected,
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
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(100),
                  bottomLeft: Radius.circular(100),
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

class Sidebar extends StatelessWidget {
  final bool isCollapsed;
  final VoidCallback toggleCollapse;
  final List<SidebarItemModel> items;
  final VoidCallback onRoleSwitch;
  final bool isRfi;

  const Sidebar({
    super.key,
    required this.isCollapsed,
    required this.toggleCollapse,
    required this.items,
    required this.onRoleSwitch,
    required this.isRfi,
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
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: MediaQuery.of(context).size.height * 0.1125,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(32)),
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

          // Criteria + RFI
          Container(
            child: Column(
              children: [
                ...items.map((item) {
                  return isCollapsed
                      ? _CollapsedSidebarItem(
                        icon: item.icon,
                        tooltip: item.label,
                        onTap: item.onTap,
                        isSelected: item.isSelected,
                      )
                      : _ExpandedSidebarItem(
                        icon: item.icon,
                        label: item.label,
                        onTap: item.onTap,
                        isSelected: item.isSelected,
                      );
                }),
              ],
            ),
          ),

          const Spacer(flex: 2),

          // Profile + Switch to admin button
          Container(
            child: Column(
              children: [
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
                              'Switch to ${isRfi ? 'Admin' : 'User'}',
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
                  isCollapsed: isCollapsed,
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
              ],
            ),
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
