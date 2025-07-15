import 'package:flutter/material.dart';

import '../views/add_rfi_flow.dart';

void showAddRFIModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.all(24),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: const AddRFIDocumentPage(),
        ),
      );
    },
  );
}
