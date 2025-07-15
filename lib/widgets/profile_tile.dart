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
      margin: const EdgeInsets.all(12),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
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
