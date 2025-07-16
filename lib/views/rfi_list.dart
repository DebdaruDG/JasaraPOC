import 'package:flutter/material.dart';
import 'package:jasara_poc/widgets/utils/app_textStyles.dart';
import '../models/rfi_model.dart';
import '../widgets/generic_data_table.dart';
import '../widgets/popup_action_menu.dart';
import '../widgets/rfi_result_indicator.dart';
import '../widgets/rfi_stat_card.dart';
import '../models/rfi_stat_model.dart';
import '../widgets/add_rfi_document_modal.dart';
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
        gradientColors: [JasaraPalette.indigoBlue, JasaraPalette.primary],
      ),
      RFIStatModel(
        label: 'Go',
        value: '122',
        icon: Icons.check_circle,
        gradientColors: [JasaraPalette.aquaGreen, JasaraPalette.skyBlue],
      ),
      RFIStatModel(
        label: 'No Go',
        value: '30',
        icon: Icons.cancel,
        gradientColors: [JasaraPalette.primary, JasaraPalette.indigoBlue],
      ),
      RFIStatModel(
        label: 'Need Review',
        value: '1',
        icon: Icons.help,
        gradientColors: [JasaraPalette.skyBlue, JasaraPalette.aquaGreen],
      ),
    ];

    final List<RFIModel> rfis = [
      RFIModel(
        title: 'Tower Crane Safety',
        comment: 'AI detected optimal safety standards across all criteria.',
        fileName: 'crane_report.pdf',
        fileUrl: 'assets/docs/crane_report.pdf',
        percentage: 92,
        result: 'GO',
      ),
      RFIModel(
        title: 'Concrete Mix Consistency',
        comment: 'Minor inconsistency in batch 3. Suggested retest.',
        fileName: 'batch_analysis.xlsx',
        fileUrl: 'assets/docs/batch_analysis.xlsx',
        percentage: 85,
        result: 'GO',
      ),
      RFIModel(
        title: 'Scaffolding Load Test',
        comment: 'Load capacity below safe threshold. Adjustments required.',
        fileName: 'scaffold_test.pdf',
        fileUrl: 'assets/docs/scaffold_test.pdf',
        percentage: 42,
        result: 'NO GO',
      ),
    ];

    return Scaffold(
      backgroundColor: JasaraPalette.greyShade100,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 45.0),
        child: Column(
          children: [
            /// Stats Row
            /// Stats Responsive Layout (2x2 on mobile/tablet)
            LayoutBuilder(
              builder: (context, constraints) {
                double width = constraints.maxWidth;
                int crossAxisCount = width < 1024 ? 2 : 4;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: stats.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisExtent: 120,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder:
                      (context, index) => RFIStatCard(stat: stats[index]),
                );
              },
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
                    buttonWidth = 85;
                  } else if (screenWidth < 1024) {
                    buttonWidth = 105;
                  } else {
                    buttonWidth = 125;
                  }

                  return CustomButton2(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: Icon(
                        Icons.add,
                        color: JasaraPalette.background,
                        size: 24,
                      ),
                    ),
                    label: "New RFI",
                    textStyle: JasaraTextStyles.primaryText500.copyWith(
                      color: JasaraPalette.background,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    height: 50,
                    width: buttonWidth,
                    backgroundColor: JasaraPalette.indigoBlue,
                    onPressed: () => showAddRFIModal(context),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: JasaraPalette.scaffoldBackground,
                backgroundBlendMode: BlendMode.clear,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: GenericDataTable(
                columnFlexes: [1, 5, 2, 2, 1],
                columnTitles: const [
                  'Project',
                  'AI Comments',
                  'RFI Files',
                  'Result',
                  '',
                ],
                rowData:
                    rfis.map((item) {
                      return [
                        Text(item.title, textAlign: TextAlign.center),
                        Text(item.comment, textAlign: TextAlign.center),
                        Text(
                          item.fileName,
                          style: const TextStyle(color: Colors.blue),
                        ),
                        RFIResultIndicator(rfi: item),
                        PopupActionMenu(
                          onEdit: () => debugPrint('Edit: ${item.title}'),
                          onArchive: () => debugPrint('Archive: ${item.title}'),
                          onDelete: () => debugPrint('Delete: ${item.title}'),
                        ),
                      ];
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
