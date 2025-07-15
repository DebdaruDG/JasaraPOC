import 'package:flutter/material.dart';
import '../../widgets/add_rfi_document_modal.dart';
import '../../widgets/generic_data_table.dart';
import '../../widgets/popup_action_menu.dart';
import '../../widgets/utils/app_button.dart';
import '../../widgets/utils/app_palette.dart';

class RFIListPage extends StatelessWidget {
  const RFIListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> dummyData = [
      {
        'title': 'Model Accuracy',
        'instruction': 'Evaluate AI model accuracy...',
      },
      {
        'title': 'Data Pipeline Efficiency',
        'instruction': 'Assess pipeline performance...',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double screenWidth = constraints.maxWidth;

                  double buttonWidth;
                  if (screenWidth < 600) {
                    // Mobile view
                    buttonWidth = 140;
                  } else if (screenWidth < 1024) {
                    // Tablet view
                    buttonWidth = 180;
                  } else {
                    // Desktop / Web view
                    buttonWidth = 220;
                  }

                  return CustomButton2(
                    label: "+ New RFI",
                    width: buttonWidth,
                    backgroundColor: JasaraPalette.primary,
                    onPressed: () => showAddRFIModal(context),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            GenericDataTable(
              columnTitles: const [
                'Title',
                'Instructions',
                'Supporting Files',
                'Actions',
              ],
              rowData:
                  dummyData.map((item) {
                    return [
                      Text(item['title']!),
                      Text(item['instruction']!),
                      const Row(
                        children: [
                          Icon(Icons.picture_as_pdf, size: 16),
                          SizedBox(width: 4),
                          Text("Uploads"),
                        ],
                      ),
                      PopupActionMenu(
                        onEdit: () => debugPrint('Edit: ${item['title']}'),
                        onArchive:
                            () => debugPrint('Archive: ${item['title']}'),
                        onDelete: () => debugPrint('Delete: ${item['title']}'),
                      ),
                    ];
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
