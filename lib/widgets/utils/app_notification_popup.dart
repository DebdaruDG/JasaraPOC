// notification_bell_button.dart
import 'package:flutter/material.dart';

import 'app_palette.dart';

class NotificationBellButton extends StatelessWidget {
  final List<String> notifications;

  const NotificationBellButton({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: JasaraPalette.scaffoldBackground,
      tooltip: "Notifications",
      offset: const Offset(0, 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(
            Icons.notifications_outlined,
            size: 36,
            color: JasaraPalette.dark1,
          ),
          if (notifications.isNotEmpty)
            Positioned(
              right: 0,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "${notifications.length}",
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
        ],
      ),
      itemBuilder:
          (context) =>
              notifications.map((note) {
                return PopupMenuItem<String>(
                  value: note,
                  child: Row(
                    children: [
                      Icon(
                        note.contains("NO GO")
                            ? Icons.circle
                            : Icons.check_circle,
                        color:
                            note.contains("NO GO") ? Colors.red : Colors.green,
                        size: 10,
                      ),
                      const SizedBox(width: 8),
                      Flexible(child: Text(note)),
                    ],
                  ),
                );
              }).toList(),
    );
  }
}
