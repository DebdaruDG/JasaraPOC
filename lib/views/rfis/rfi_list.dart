import 'package:flutter/material.dart';
import 'package:jasara_poc/widgets/utils/app_textStyles.dart';
import 'package:jasara_poc/widgets/utils/app_palette.dart';
import '../../models/rfi_model.dart';
import '../../widgets/generic_data_table.dart';
import '../../widgets/popup_action_menu.dart';
import '../../widgets/rfi_result_indicator.dart';
import '../../widgets/rfi_stat_card.dart';
import '../../models/rfi_stat_model.dart';
import '../../widgets/add_rfi_document_modal.dart';
import '../../widgets/utils/app_button.dart';
import 'package:provider/provider.dart';
import '../../providers/assessment_provider.dart';
import 'dart:developer' as console;

class RFIListPage extends StatelessWidget {
  const RFIListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final assessmentProvider = Provider.of<AssessmentProvider>(context);

    return FutureBuilder<List<RFIModel>>(
      future: assessmentProvider.fetchRFIs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          console.log('Error fetching RFIs: ${snapshot.error}');
          return Center(child: Text('Error loading RFIs: ${snapshot.error}'));
        }
        final rfis = snapshot.data ?? [];

        final List<RFIStatModel> stats = [
          RFIStatModel(
            label: 'RFIs Assessed',
            value: rfis.length.toString(),
            icon: Icons.fact_check,
            gradientColors: [JasaraPalette.indigoBlue, JasaraPalette.primary],
          ),
          RFIStatModel(
            label: 'Go',
            value: rfis.where((r) => r.result == 'GO').length.toString(),
            icon: Icons.check_circle,
            gradientColors: [JasaraPalette.aquaGreen, JasaraPalette.skyBlue],
          ),
          RFIStatModel(
            label: 'No Go',
            value: rfis.where((r) => r.result == 'NO GO').length.toString(),
            icon: Icons.cancel,
            gradientColors: [JasaraPalette.primary, JasaraPalette.indigoBlue],
          ),
          RFIStatModel(
            label: 'Need Review',
            value: rfis.where((r) => r.result == 'REVIEW').length.toString(),
            icon: Icons.help,
            gradientColors: [JasaraPalette.skyBlue, JasaraPalette.aquaGreen],
          ),
        ];

        return Scaffold(
          backgroundColor: JasaraPalette.greyShade100,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45.0),
            child: Column(
              children: [
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
                              onEdit:
                                  () => assessmentProvider.updateRFI(
                                    documentId:
                                        rfis
                                            .firstWhere(
                                              (r) => r.title == item.title,
                                              orElse:
                                                  () => RFIModel(
                                                    id: '',
                                                    title: '',
                                                    comment: '',
                                                    fileName: '',
                                                    fileUrl:
                                                        item.fileUrl, // Use current item's fileUrl
                                                    percentage: 0,
                                                    result: '',
                                                  ),
                                            )
                                            .fileUrl,
                                    title: item.title,
                                    comment: item.comment,
                                    fileName: item.fileName,
                                    fileUrl: item.fileUrl,
                                    percentage: item.percentage.toDouble(),
                                    result: item.result,
                                  ),
                              onArchive:
                                  () => assessmentProvider.archiveRFI(
                                    rfis
                                        .firstWhere(
                                          (r) => r.title == item.title,
                                          orElse:
                                              () => RFIModel(
                                                id: '',
                                                title: '',
                                                comment: '',
                                                fileName: '',
                                                fileUrl:
                                                    item.fileUrl, // Use current item's fileUrl
                                                percentage: 0,
                                                result: '',
                                              ),
                                        )
                                        .fileUrl,
                                  ),
                              onDelete:
                                  () => assessmentProvider.deleteRFI(
                                    item.id,
                                    // rfis
                                    //     .firstWhere(
                                    //       (r) => r.title == item.title,
                                    //       orElse:
                                    //           () => RFIModel(
                                    //             title: '',
                                    //             comment: '',
                                    //             fileName: '',
                                    //             fileUrl:
                                    //                 item.fileUrl, // Use current item's fileUrl
                                    //             percentage: 0,
                                    //             result: '',
                                    //           ),
                                    //     )
                                    //     .fileUrl,
                                  ),
                            ),
                          ];
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
