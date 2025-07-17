import 'dart:developer' as console;
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:html' as html;

import '../../providers/add_rfi_provider.dart';
import '../../providers/assessment_page_provider.dart';
import '../../providers/criteria_provider.dart';
import '../../providers/assessment_provider.dart';
import '../../providers/screen_switch_provider.dart';
import '../../widgets/utils/app_button.dart';
import '../../widgets/utils/app_palette.dart';
import '../../widgets/utils/app_textStyles.dart';
import '../../widgets/utils/app_text_field.dart';
import '../../widgets/utils/app_toast.dart';
import '../../models/response/evaluate_response_model.dart';

class AddRFIDocumentPage extends StatefulWidget {
  const AddRFIDocumentPage({super.key});

  @override
  State<AddRFIDocumentPage> createState() => _AddRFIDocumentPageState();
}

class _AddRFIDocumentPageState extends State<AddRFIDocumentPage> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Consumer4<
      HomePageProvider,
      CriteriaProvider,
      AssessmentProvider,
      ScreenSwitchProvider
    >(
      builder: (
        context,
        provider,
        criteriaProvider,
        assessmentProvider,
        screenProvider,
        _,
      ) {
        return SingleChildScrollView(
          child:
              screenProvider.showAssessment
                  ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 18,
                            bottom: 16,
                            top: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "AI Assessment",
                                style: JasaraTextStyles.primaryText500.copyWith(
                                  fontSize: 18,
                                  color: JasaraPalette.dark2,
                                ),
                              ),
                              InkWell(
                                onTap:
                                    () =>
                                        screenProvider.toggleAssessment(false),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: JasaraPalette.dark2,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Consumer2<AssessmentProvider, CriteriaProvider>(
                          builder: (
                            context,
                            assessmentProvider,
                            criteriaProvider,
                            _,
                          ) {
                            final total =
                                criteriaProvider.criteriaListResponse.length;
                            final completed =
                                assessmentProvider.evaluateResponses.length;

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Counter: $completed of $total",
                                      style: JasaraTextStyles.primaryText500
                                          .copyWith(
                                            fontSize: 16,
                                            color: JasaraPalette.dark2,
                                          ),
                                    ),
                                    SparkleAnimation(
                                      child: Text(
                                        'Final Score - ${assessmentProvider.averageScore.toStringAsFixed(2)}',
                                        style: JasaraTextStyles.primaryText500
                                            .copyWith(
                                              fontSize: 16,
                                              color: JasaraPalette.primary,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Expanded(
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: total,
                                    itemBuilder: (context, index) {
                                      final criteria =
                                          criteriaProvider
                                              .criteriaListResponse[index];
                                      final assistantId = criteria.assistantId;

                                      final matchedResponse = assessmentProvider
                                          .evaluateResponses
                                          .firstWhere(
                                            (e) => e.results.any(
                                              (r) =>
                                                  r.assistantId == assistantId,
                                            ),
                                            orElse:
                                                () => EvaluateResponse(
                                                  document: '',
                                                  results: [],
                                                ),
                                          );

                                      return _buildCriteriaItem(
                                        context,
                                        matchedResponse,
                                        index,
                                        assistantId: assistantId,
                                        criteriaLabel: criteria.title,
                                        isLoading: assessmentProvider.loadingIds
                                            .contains(assistantId),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  )
                  : Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 18,
                            bottom: 16,
                            top: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Please upload the RFP Document and fill the form below",
                                style: JasaraTextStyles.primaryText500.copyWith(
                                  fontSize: 20,
                                  color: JasaraPalette.dark2,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Icon(
                                  Icons.cancel,
                                  color: Colors.redAccent,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildFileUploadField(context, provider),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          children: [
                            ...provider.controllers.keys
                                .where((key) => key != 'opportunityCode')
                                .map((key) {
                                  return SizedBox(
                                    width:
                                        isWide
                                            ? MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.3
                                            : double.infinity,
                                    child: AppTextField(
                                      label: key
                                          .replaceAllMapped(
                                            RegExp(r'(?<=[a-z])([A-Z])'),
                                            (Match m) => ' ${m[1]}',
                                          )
                                          .split(' ')
                                          .map(
                                            (word) =>
                                                word[0].toUpperCase() +
                                                word.substring(1),
                                          )
                                          .join(' '),
                                      controller: provider.controllers[key]!,
                                    ),
                                  );
                                })
                                .toList(),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomButton2(
                              label: "Submit",
                              backgroundColor: JasaraPalette.teal,
                              width: MediaQuery.of(context).size.width * 0.6125,
                              onPressed: () async {
                                await criteriaProvider.fetchCriteriaList();

                                if (criteriaProvider
                                    .criteriaListResponse
                                    .isEmpty) {
                                  JasaraToast.error(
                                    context,
                                    "No criteria found. Please add criteria first.",
                                  );
                                  return;
                                }

                                if (provider.uploadedFileHtml == null &&
                                    provider.uploadedFile == null) {
                                  JasaraToast.error(
                                    context,
                                    "Please upload the RFI / RFP document first",
                                  );
                                  return;
                                }

                                final formJson = {
                                  'opportunityName':
                                      provider
                                          .controllers['opportunityName']!
                                          .text,
                                  'date': provider.controllers['date']!.text,
                                  'proposalManager':
                                      provider
                                          .controllers['proposalManager']!
                                          .text,
                                  'description':
                                      provider.controllers['description']!.text,
                                  'projectType':
                                      provider.controllers['projectType']!.text,
                                  'clientName':
                                      provider.controllers['clientName']!.text,
                                  'clientType':
                                      provider.controllers['clientType']!.text,
                                  'relationship':
                                      provider
                                          .controllers['relationship']!
                                          .text,
                                  'submissionDate':
                                      provider
                                          .controllers['submissionDate']!
                                          .text,
                                  'biddingCriteria':
                                      provider
                                          .controllers['biddingCriteria']!
                                          .text,
                                  'isTargeted':
                                      provider.controllers['isTargeted']!.text,
                                  'comments':
                                      provider.controllers['comments']!.text,
                                  'project_name':
                                      provider
                                          .controllers['project_name']!
                                          .text,
                                  'budget':
                                      provider.controllers['budget']!.text,
                                  'location':
                                      provider.controllers['location']!.text,
                                };

                                final file =
                                    provider.uploadedFileHtml ??
                                    (provider.uploadedFile != null
                                        ? html.File(
                                          [],
                                          provider.uploadedFileName ??
                                              'unknown.pdf',
                                        )
                                        : null);

                                if (file == null) {
                                  JasaraToast.error(
                                    context,
                                    "Failed to process the uploaded file.",
                                  );
                                  return;
                                }

                                screenProvider.toggleAssessment(
                                  true,
                                  formJson: formJson,
                                  file: file,
                                );
                                await assessmentProvider
                                    .clearEvaluateResponses();
                                for (var item
                                    in criteriaProvider.criteriaListResponse) {
                                  try {
                                    await assessmentProvider.evaluateBE(
                                      formJson,
                                      item.assistantId,
                                      file,
                                    );
                                  } catch (e) {
                                    console.log(
                                      "Error submitting evaluation: $e",
                                    );
                                    JasaraToast.error(
                                      context,
                                      "An error occurred during evaluation: $e",
                                    );
                                  }
                                }
                                console.log("Form submitted");
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
        );
      },
    );
  }

  Widget _buildFileUploadField(
    BuildContext context,
    HomePageProvider provider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (provider.uploadedFile != null || provider.uploadedFileHtml != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Chip(
              label: Text(
                provider.uploadedFileName ??
                    (kIsWeb
                        ? provider.uploadedFileHtml?.name
                        : provider.uploadedFile?.path.split("/").last) ??
                    'unknown.pdf',
                style: JasaraTextStyles.primaryText400,
              ),
              deleteIcon: const Icon(Icons.delete, size: 18, color: Colors.red),
              onDeleted: () {
                provider.setUploadedFile(null, null);
              },
              backgroundColor: JasaraPalette.white,
              side: BorderSide(color: JasaraPalette.primary.withOpacity(0.4)),
            ),
          ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomButton2(
              label:
                  provider.uploadedFile == null &&
                          provider.uploadedFileHtml == null
                      ? "Upload RFP Document"
                      : "Replace RFP Document",
              prefixIcon: const Icon(
                Icons.attach_file,
                color: JasaraPalette.white,
                size: 20,
              ),
              backgroundColor: JasaraPalette.indigoBlue,
              height: 50,
              onPressed:
                  provider.uploadedFile == null &&
                          provider.uploadedFileHtml == null
                      ? () async {
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                          withData: true,
                        );
                        if (result != null &&
                            result.files.single.size <= 500 * 1024) {
                          final name = result.files.single.name;
                          if (kIsWeb) {
                            final bytes = result.files.single.bytes;
                            if (bytes != null) {
                              final htmlFile = html.File([bytes], name);
                              provider.setUploadedFile(htmlFile, null, name);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("PDF uploaded successfully"),
                                ),
                              );
                            }
                          } else {
                            final path = result.files.single.path;
                            if (path != null) {
                              final ioFile = File(path);
                              provider.setUploadedFile(null, ioFile, name);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("PDF uploaded successfully"),
                                ),
                              );
                            }
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("File size exceeds 500KB limit"),
                            ),
                          );
                        }
                      }
                      : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCriteriaItem(
    BuildContext context,
    EvaluateResponse? model,
    int index, {
    required String assistantId,
    required String criteriaLabel,
    required bool isLoading,
  }) {
    final hasData = model != null && model.results.isNotEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: JasaraPalette.primary.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Criteria ${index + 1}: $criteriaLabel",
            style: JasaraTextStyles.primaryText500.copyWith(
              fontSize: 16,
              color: JasaraPalette.dark2,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child:
                isLoading || !hasData
                    ? _buildSparkleLoader()
                    : Text(
                      model.results[0].summary.toString(),
                      style: JasaraTextStyles.primaryText400.copyWith(
                        fontSize: 14,
                        color: JasaraPalette.dark2,
                      ),
                    ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: SparkleAnimation(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: JasaraPalette.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "Score: ${hasData ? model.results[0].score.toString() : "--"}",
                  style: JasaraTextStyles.primaryText500.copyWith(
                    fontSize: 14,
                    color: JasaraPalette.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSparkleLoader() {
    return SizedBox(
      height: 40,
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(seconds: 1),
          builder: (context, value, child) {
            return Opacity(
              opacity: 0.5 + 0.5 * (1 - (value - 0.5).abs() * 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.auto_awesome, color: JasaraPalette.primary),
                  SizedBox(width: 8),
                  Text("Thinking...", style: JasaraTextStyles.primaryText400),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
