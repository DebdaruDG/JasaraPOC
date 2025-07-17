import 'package:flutter/material.dart';

import '../views/rfis/add_rfi_flow.dart';
import 'utils/app_palette.dart';

void showAddRFIModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.all(24),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          decoration: BoxDecoration(color: JasaraPalette.scaffoldBackground),
          padding: const EdgeInsets.all(16),
          child: const AddRFIDocumentPage(),
        ),
      );
    },
  );
}
