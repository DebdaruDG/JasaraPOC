import 'dart:developer' as console;
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:html' as html;

import '../../providers/add_rfi_provider.dart';
import '../../providers/criteria_provider.dart';
import '../../widgets/utils/app_button.dart';
import '../../widgets/utils/app_palette.dart';
import '../../widgets/utils/app_textStyles.dart';
import '../../widgets/utils/app_text_field.dart';
import '../../widgets/utils/app_toast.dart';
import '../criterias/assessment_page.dart';

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

    return ChangeNotifierProvider(
      create: (_) => HomePageProvider(),
      child: Consumer<HomePageProvider>(
        builder: (context, provider, _) {
          final threeFields = [
            AppTextField(
              label: "Project Name",
              controller: provider.controllers['project_name']!,
            ),
            AppTextField(
              label: "Location",
              controller: provider.controllers['location']!,
            ),
            AppTextField(
              label: "Budget",
              controller: provider.controllers['budget']!,
            ),
          ];

          final thirteenFields = [
            AppTextField(
              label: "Opportunity Name",
              controller: provider.controllers['opportunityName']!,
            ),
            AppTextField(
              label: "Date",
              controller: provider.controllers['date']!,
            ),
            AppTextField(
              label: "Proposal Manager",
              controller: provider.controllers['proposalManager']!,
            ),
            AppTextField(
              label: "Brief Description of Work",
              controller: provider.controllers['description']!,
            ),
            AppTextField(
              label: "Project Type",
              controller: provider.controllers['projectType']!,
            ),
            AppTextField(
              label: "Client Name",
              controller: provider.controllers['clientName']!,
            ),
            AppTextField(
              label: "Client Type",
              controller: provider.controllers['clientType']!,
            ),
            AppTextField(
              label: "Relationship with Client",
              controller: provider.controllers['relationship']!,
            ),
            AppTextField(
              label: "Submission Date",
              controller: provider.controllers['submissionDate']!,
            ),
            AppTextField(
              label: "Bidding Criteria",
              controller: provider.controllers['biddingCriteria']!,
            ),
            AppTextField(
              label: "Is it a Targeted Proposal?",
              controller: provider.controllers['isTargeted']!,
            ),
            AppTextField(
              label: "Comments",
              controller: provider.controllers['comments']!,
            ),
          ];

          return SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 18),
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
                    children:
                        thirteenFields.map((field) {
                          return SizedBox(
                            width:
                                isWide
                                    ? MediaQuery.of(context).size.width * 0.3
                                    : double.infinity,
                            child: field,
                          );
                        }).toList(),
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
                          final criteriaProvider =
                              Provider.of<CriteriaProvider>(
                                context,
                                listen: false,
                              );

                          await criteriaProvider.fetchCriteriaList();

                          if (criteriaProvider.criteriaListResponse.isEmpty) {
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

                          if (formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => AssessmentPage(
                                      file:
                                          provider.uploadedFileHtml ??
                                          (provider.uploadedFile != null
                                              ? html.File(
                                                [], // Empty bytes, as dart:io File is used
                                                provider.uploadedFileName ??
                                                    'unknown.pdf',
                                              )
                                              : null),
                                      formJson: {
                                        'opportunityName':
                                            provider
                                                .controllers['opportunityName']!
                                                .text,
                                        'date':
                                            provider.controllers['date']!.text,
                                        'proposalManager':
                                            provider
                                                .controllers['proposalManager']!
                                                .text,
                                        'description':
                                            provider
                                                .controllers['description']!
                                                .text,
                                        'projectType':
                                            provider
                                                .controllers['projectType']!
                                                .text,
                                        'clientName':
                                            provider
                                                .controllers['clientName']!
                                                .text,
                                        'clientType':
                                            provider
                                                .controllers['clientType']!
                                                .text,
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
                                            provider
                                                .controllers['isTargeted']!
                                                .text,
                                        'comments':
                                            provider
                                                .controllers['comments']!
                                                .text,
                                      },
                                    ),
                              ),
                            );
                            console.log("Form submitted");
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFileUploadField(
    BuildContext context,
    HomePageProvider provider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display uploaded file if present
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
        // Upload button
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
                          withData: true, // Include bytes for web
                        );
                        if (result != null &&
                            result.files.single.size <= 500 * 1024) {
                          final name = result.files.single.name;
                          if (kIsWeb) {
                            final bytes = result.files.single.bytes;
                            if (bytes != null && name != null) {
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
                        } else if (result != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("File size exceeds 500KB limit"),
                            ),
                          );
                        }
                      }
                      : null, // Disable button if a file is already uploaded
            ),
          ),
        ),
      ],
    );
  }
}
