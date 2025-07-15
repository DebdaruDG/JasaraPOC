import 'package:flutter/material.dart';
import '../widgets/rfi_stat_card.dart';
import '../models/rfi_stat_model.dart';
import '../widgets/add_rfi_document_modal.dart';
import '../widgets/generic_data_table.dart';
import '../widgets/popup_action_menu.dart';
import '../widgets/utils/app_button.dart';
import '../widgets/utils/app_palette.dart';

class RFIListPage extends StatelessWidget {
  const RFIListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<RFIStatModel> stats = [
      RFIStatModel(
        label: 'RFIs Assessed',
        value: '152',
        icon: Icons.fact_check,
        gradientColors: [
          JasaraPalette.primary.withOpacity(0.5),
          JasaraPalette.primary,
        ],
      ),
      RFIStatModel(
        label: 'Go',
        value: '122',
        icon: Icons.check_circle,
        gradientColors: [
          JasaraPalette.green.withOpacity(0.4),
          JasaraPalette.green,
        ],
      ),
      RFIStatModel(
        label: 'No Go',
        value: '30',
        icon: Icons.cancel,
        gradientColors: [
          JasaraPalette.red.withOpacity(0.4),
          JasaraPalette.red.withOpacity(0.75),
        ],
      ),
      RFIStatModel(
        label: 'Need Review',
        value: '1',
        icon: Icons.help,
        gradientColors: [
          JasaraPalette.yellow.withOpacity(0.65),
          JasaraPalette.yellow.withOpacity(0.95),
        ],
      ),
    ];

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
            /// Stats Row
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: stats.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  return RFIStatCard(stat: stats[index]);
                },
              ),
            ),

            const SizedBox(height: 24),

            /// New RFI Button
            Align(
              alignment: Alignment.centerRight,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double screenWidth = constraints.maxWidth;
                  double buttonWidth;

                  if (screenWidth < 600) {
                    buttonWidth = 140;
                  } else if (screenWidth < 1024) {
                    buttonWidth = 180;
                  } else {
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

            /// RFI Table
            GenericDataTable(
              columnTitles: const [
                'Project',
                'AI Comments',
                'RFI Files',
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
