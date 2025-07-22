import 'package:flutter/material.dart';
import 'package:jasara_poc/widgets/utils/app_textStyles.dart';
import 'package:jasara_poc/widgets/utils/app_palette.dart';
import '../../models/evaluate_assessment_firebase_model.dart';
import '../../models/response/evaluate_response_model.dart';
import '../../providers/screen_switch_provider.dart';
import '../../widgets/generic_data_table.dart';
import '../../widgets/popup_action_menu.dart';
import '../../widgets/rfi_result_indicator.dart';
import '../../widgets/rfi_stat_card.dart';
import '../../models/rfi_stat_model.dart';
import '../../widgets/add_rfi_document_modal.dart';
import '../../widgets/utils/app_button.dart';
import 'package:provider/provider.dart';
import '../../providers/assessment_provider.dart';
import '../criterias/criterias_list.dart';

class RFIListPage extends StatefulWidget {
  const RFIListPage({super.key});

  @override
  State<RFIListPage> createState() => _RFIListPageState();
}

class _RFIListPageState extends State<RFIListPage> {
  // Dummy Variables
  List<EvaluateResponse> dummyEvaluateResponses = [];
  List<String> dummyCriteriaList = [];
  double dummyAverageScore = 0.0;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AssessmentProvider>(context, listen: false);
    final screenSwitchProvider = Provider.of<ScreenSwitchProvider>(
      context,
      listen: false,
    );
    Future.delayed(Duration.zero, () async {
      await provider.fetchRFIs();
      screenSwitchProvider.toggleAssessment(false);
    });
    dummyEvaluateResponses = [
      EvaluateResponse(
        document: "doc_001",
        results: [
          EvaluateResult(
            assistantId: "assistant_1",
            criteria: "Clarity",
            summary: "Very clear response.",
            score: 8.5,
          ),
          EvaluateResult(
            assistantId: "assistant_2",
            criteria: "Relevance",
            summary: "Relevant to the context.",
            score: 9.0,
          ),
          EvaluateResult(
            assistantId: "assistant_3",
            criteria: "Feasibility",
            summary: "Feasible and well structured.",
            score: 7.5,
          ),
        ],
      ),
      EvaluateResponse(
        document: "doc_002",
        results: [
          EvaluateResult(
            assistantId: "assistant_4",
            criteria: "Innovation",
            summary: "Highly innovative ideas.",
            score: 9.2,
          ),
        ],
      ),
    ];

    dummyCriteriaList = ["Clarity", "Relevance", "Feasibility", "Innovation"];

    dummyAverageScore = 8.55; // Out of 10
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssessmentProvider>(
      builder: (context, provider, _) {
        final List<RFIStatModel> stats = [
          RFIStatModel(
            label: 'RFIs Assessed',
            value: (provider.rfis.data ?? []).length.toString(),
            icon: Icons.fact_check,
            gradientColors: [JasaraPalette.indigoBlue, JasaraPalette.primary],
          ),
          RFIStatModel(
            label: 'Go',
            value:
                (provider.rfis.data ?? [])
                    .where((r) => r.result == 'GO')
                    .length
                    .toString(),
            icon: Icons.check_circle,
            gradientColors: [JasaraPalette.aquaGreen, JasaraPalette.skyBlue],
          ),
          RFIStatModel(
            label: 'No Go',
            value:
                (provider.rfis.data ?? [])
                    .where((r) => r.result == 'NO GO')
                    .length
                    .toString(),
            icon: Icons.cancel,
            gradientColors: [JasaraPalette.primary, JasaraPalette.indigoBlue],
          ),
          RFIStatModel(
            label: 'Need Review',
            value:
                (provider.rfis.data ?? [])
                    .where((r) => r.result == 'REVIEW')
                    .length
                    .toString(),
            icon: Icons.help,
            gradientColors: [JasaraPalette.skyBlue, JasaraPalette.aquaGreen],
          ),
        ];

        return Scaffold(
          backgroundColor: JasaraPalette.greyShade100,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45.0),
            child: SingleChildScrollView(
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
                  // Dummy Purpose - For Styling.
                  // TopScorePieChart(
                  //   evaluateResponses: dummyEvaluateResponses,
                  //   averageScore: dummyAverageScore,
                  //   criteriaList: dummyCriteriaList,
                  //   isLoading: false,
                  // ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: JasaraPalette.scaffoldBackground,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: GenericDataTable(
                      columnFlexes: [2, 5, 2, 2, 1],
                      columnTitles: const [
                        'Project',
                        'AI Comments',
                        'RFI Files',
                        'Result',
                        '',
                      ],
                      rowData:
                          (provider.rfis.data ?? []).map((item) {
                            return [
                              Text(item.title, textAlign: TextAlign.left),
                              Text(
                                item.summarizerComment,
                                maxLines: 3,
                                softWrap: true,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  showPDFViewerDialog(
                                    context,
                                    item.fileName.isEmpty
                                        ? 'No-Name'
                                        : item.fileName,
                                    item.fileUrl,
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.picture_as_pdf,
                                        size: 18,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 4),

                                      Flexible(
                                        child: Text(
                                          item.fileName,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(
                                        Icons.visibility,
                                        size: 18,
                                        color: JasaraPalette.deepIndigo,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              RFIResultIndicator(rfi: item),
                              PopupActionMenu(
                                onEdit:
                                    () => provider.updateRFI(
                                      documentId: item.fileUrl,
                                      title: item.title,
                                      comment: item.comment,
                                      fileName: item.fileName,
                                      fileUrl: item.fileUrl,
                                      percentage: item.percentage.toDouble(),
                                      result: item.result,
                                    ),
                                onArchive:
                                    () => provider.archiveRFI(item.fileUrl),
                                onDelete: () async {
                                  await provider.deleteRFI(context, item.id);
                                  Future.delayed(
                                    Duration.zero,
                                    () async => await provider.fetchRFIs(),
                                  );
                                },
                              ),
                            ];
                          }).toList(),
                    ),
                  ),
                  if ((provider.rfis.data ?? []).isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Nothing to Show !'),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
