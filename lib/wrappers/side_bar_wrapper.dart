import 'dart:developer' as console;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jasara_poc/widgets/utils/app_palette.dart';
import 'package:jasara_poc/widgets/utils/app_textStyles.dart';

import '../models/sidebarItemModel.dart';
import '../widgets/collapsed_sidebar_widget.dart';
import '../widgets/expanded_sidebar_widget.dart';
import '../widgets/profile_tile.dart';

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
    bool isCriteriaSelected = items.any(
      (item) => item.label.toUpperCase() == 'CRITERIA' && item.isSelected,
    );
    bool isRfiSelected = items.any(
      (item) => item.label.toUpperCase() == 'RFI' && item.isSelected,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isCollapsed ? 70 : 300,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: JasaraPalette.deepIndigo,
        borderRadius: const BorderRadius.only(topRight: Radius.circular(80)),
      ),
      child: Container(
        decoration: BoxDecoration(color: JasaraPalette.background),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Logo/Header
            Container(
              width: isCollapsed ? 70 : 300,
              height: MediaQuery.of(context).size.height * 0.4,
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: MediaQuery.of(context).size.height * 0.1125,
              ),
              decoration: BoxDecoration(
                color: JasaraPalette.deepIndigo,
                borderRadius: BorderRadius.only(
                  bottomRight:
                      isCriteriaSelected ? Radius.circular(80) : Radius.zero,
                  topRight: Radius.circular(120),
                ),
              ),
              child:
                  isCollapsed
                      ? jasaraIconSVGLogo(45)
                      : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [jasaraSVGLogo(45)],
                      ),
            ),
            // Criteria + RFI
            Container(
              decoration: BoxDecoration(color: JasaraPalette.deepIndigo),
              child: Column(
                children: [
                  ...items.map((item) {
                    return isCollapsed
                        ? CollapsedSidebarItem(
                          icon: item.icon,
                          tooltip: item.label,
                          onTap: item.onTap,
                          isSelected: item.isSelected,
                        )
                        : ExpandedSidebarItem(
                          icon: item.icon,
                          label: item.label,
                          onTap: item.onTap,
                          isSelected: item.isSelected,
                          isCriteriaSelected: isCriteriaSelected,
                          isRfiSelected: isRfiSelected,
                        );
                  }),
                ],
              ),
            ),

            // Profile + Switch to admin button
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 100),
                decoration: BoxDecoration(
                  color: JasaraPalette.deepIndigo,
                  borderRadius: BorderRadius.only(
                    topRight: isRfiSelected ? Radius.circular(80) : Radius.zero,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: JasaraPalette.teal,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.swap_horiz,
                          color: Colors.white,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        title:
                            isCollapsed
                                ? null
                                : Text(
                                  'Switch to ${isRfi ? 'Admin' : 'User'}',
                                  style: JasaraTextStyles.primaryText500
                                      .copyWith(
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
                      onTap: () => console.log('Profile clicked'),
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
            ),
          ],
        ),
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
