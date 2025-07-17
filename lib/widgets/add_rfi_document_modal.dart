import 'dart:developer' as console;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../views/criterias/assessment_page.dart';
import '../views/rfis/add_rfi_flow.dart';
import '../../providers/screen_switch_provider.dart';
import 'utils/app_palette.dart';

void showAddRFIModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Consumer<ScreenSwitchProvider>(
        builder: (context, screenProvider, _) {
          console.log('showAssessment - ${screenProvider.showAssessment}');
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                insetPadding: const EdgeInsets.all(24),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.95,
                  ),
                  decoration: BoxDecoration(
                    color: JasaraPalette.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  padding: const EdgeInsets.all(16),
                  child:
                      screenProvider.showAssessment
                          ? AssessmentPage(
                            file: screenProvider.file,
                            formJson: screenProvider.formJson,
                          )
                          : const AddRFIDocumentPage(),
                ),
              );
            },
          );
        },
      );
    },
  );
}
