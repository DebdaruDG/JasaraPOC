import 'package:flutter/material.dart';
import 'package:jasara_poc/widgets/utils/app_palette.dart';

class ProfileTile extends StatelessWidget {
  final String name;
  final String title;
  final String imageUrl;
  final bool isCollapsed;
  final VoidCallback? onTap;

  const ProfileTile({
    super.key,
    required this.name,
    required this.title,
    required this.imageUrl,
    this.isCollapsed = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          isCollapsed == false
              ? const EdgeInsets.all(12)
              : const EdgeInsets.symmetric(horizontal: 4, vertical: 24),
      padding: isCollapsed == false ? const EdgeInsets.all(6) : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: JasaraPalette.primary,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage(imageUrl),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        title:
            isCollapsed
                ? null
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    if (title.isNotEmpty)
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
        onTap: onTap,
      ),
    );
  }
}
