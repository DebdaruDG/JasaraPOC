import 'package:flutter/material.dart';

import 'utils/app_palette.dart';

class PopupActionMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onArchive;
  final VoidCallback onDelete;

  const PopupActionMenu({
    super.key,
    required this.onEdit,
    required this.onArchive,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      color: JasaraPalette.scaffoldBackground,
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit();
            break;
          case 'archive':
            onArchive();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
      itemBuilder:
          (context) => [
            const PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
            const PopupMenuItem<String>(
              value: 'archive',
              child: Text('Archive'),
            ),
            const PopupMenuItem<String>(value: 'delete', child: Text('Delete')),
          ],
    );
  }
}
