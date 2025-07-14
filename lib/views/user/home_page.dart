import 'dart:developer' as console;
import 'dart:html' as html;

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import '../../providers/criteria_provider.dart';
import '../../widgets/utils/app_button.dart';
import '../../widgets/utils/app_palette.dart';
import '../../widgets/utils/app_textStyles.dart';
import '../../widgets/utils/app_text_field.dart';
import '../../widgets/utils/app_toast.dart';
import '../admin/control_panel_page.dart';
import 'assessment_page.dart';

class FileService {
  static Future<html.File?> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
      withData: true,
    );
    if (result != null && result.files.single.bytes != null) {
      final name = result.files.single.name;
      final bytes = result.files.single.bytes!;
      return html.File([bytes], name);
    }
    return null;
  }

  static Future<html.File?> handleDroppedFiles(
    List<dynamic> droppedFiles,
  ) async {
    if (droppedFiles.isEmpty) return null;

    for (var file in droppedFiles) {
      if (file is html.File) {
        if (file.name.toLowerCase().endsWith('.pdf')) {
          return file;
        }
      }
    }
    return null;
  }
}

class HomePageProvider extends ChangeNotifier {
  final Map<String, TextEditingController> _controllers = {
    'opportunityCode': TextEditingController(),
    'opportunityName': TextEditingController(),
    'date': TextEditingController(),
    'proposalManager': TextEditingController(),
    'description': TextEditingController(),
    'projectType': TextEditingController(),
    'clientName': TextEditingController(),
    'clientType': TextEditingController(),
    'relationship': TextEditingController(),
    'submissionDate': TextEditingController(),
    'biddingCriteria': TextEditingController(),
    'isTargeted': TextEditingController(),
    'comments': TextEditingController(),
    'project_name': TextEditingController(),
    'budget': TextEditingController(),
    'location': TextEditingController(),
  };

  String? _finalDecision;
  html.File? _uploadedFile;
  bool _isDragOver = false;

  Map<String, TextEditingController> get controllers => _controllers;
  String? get finalDecision => _finalDecision;
  html.File? get uploadedFile => _uploadedFile;
  bool get isDragOver => _isDragOver;

  void setFinalDecision(String? value) {
    _finalDecision = value;
    notifyListeners();
  }

  Future<void> setUploadedFile(html.File? file) async {
    _uploadedFile = file;
    notifyListeners();
  }

  void setDragOver(bool value) {
    _isDragOver = value;
    notifyListeners();
  }

  void disposeControllers() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return ChangeNotifierProvider(
      create: (_) => HomePageProvider(),
      child: Consumer<HomePageProvider>(
        builder: (context, provider, _) {
          final formKey = GlobalKey<FormState>();

          List<Widget> fields = [
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

          return Scaffold(
            backgroundColor: JasaraPalette.background,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Attach the RFP/RFI Document",
                      style: JasaraTextStyles.primaryText500.copyWith(
                        fontSize: 22,
                        color: JasaraPalette.dark2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFileUploadField(context, provider),
                    const SizedBox(height: 16),
                    Text(
                      "Fill the Go/No-Go Form",
                      style: JasaraTextStyles.primaryText500.copyWith(
                        fontSize: 22,
                        color: JasaraPalette.dark2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children:
                          fields
                              .map(
                                (field) => SizedBox(
                                  width:
                                      isWide
                                          ? MediaQuery.of(context).size.width /
                                                  2 -
                                              24
                                          : double.infinity,
                                  child: field,
                                ),
                              )
                              .toList(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton2(
                          label: "Submit",
                          backgroundColor: JasaraPalette.primary,
                          onPressed: () async {
                            final criteriaProvider =
                                Provider.of<CriteriaProvider>(
                                  context,
                                  listen: false,
                                );

                            await criteriaProvider
                                .fetchCriteriaList(); // Ensure criteria list is fetched
                            if (criteriaProvider.criteriaListResponse.isEmpty) {
                              JasaraToast.error(
                                context,
                                "No criteria found. Please add criteria first.",
                              );
                              await Future.delayed(
                                const Duration(seconds: 2),
                              ); // Show toast for 2 seconds
                              openCriteriaDialog(
                                context,
                              ); // Open the criteria dialog
                              return;
                            }
                            if (provider.uploadedFile == null) {
                              JasaraToast.error(
                                context,
                                "Please upload the RFI / RPF document first",
                              );
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => AssessmentPage(
                                      file: provider.uploadedFile!,
                                      formJson: {
                                        'project_name':
                                            provider
                                                .controllers['project_name']!
                                                .text,
                                        'budget':
                                            provider
                                                .controllers['budget']!
                                                .text,
                                        'location':
                                            provider
                                                .controllers['location']!
                                                .text,
                                      },
                                    ),
                              ),
                            );

                            if (formKey.currentState!.validate()) {
                              console.log("Form Submitted");
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
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
    return DragTarget<Object>(
      onWillAcceptWithDetails: (details) {
        provider.setDragOver(true);
        return true;
      },
      onLeave: (_) => provider.setDragOver(false),
      onAcceptWithDetails: (details) async {
        provider.setDragOver(false);
        final file = await FileService.handleDroppedFiles([details.data]);
        if (file != null) {
          provider.setUploadedFile(file);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("PDF uploaded successfully")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please drop a valid PDF file")),
          );
        }
      },
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTap: () async {
            html.File? file = await FileService.pickPDF();
            if (file != null) {
              provider.setUploadedFile(file);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("PDF uploaded successfully")),
              );
            }
          },
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            color: JasaraPalette.primary,
            dashPattern: const [8, 4],
            strokeWidth: 0.8,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color:
                    provider.isDragOver
                        ? JasaraPalette.primary.withOpacity(0.1)
                        : JasaraPalette.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  provider.uploadedFile == null
                      ? Column(
                        children: const [
                          Icon(
                            CupertinoIcons.upload_circle_fill,
                            size: 40,
                            color: JasaraPalette.primary,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Click to Upload PDF",
                            style: JasaraTextStyles.primaryText400,
                          ),
                        ],
                      )
                      : Row(
                        children: [
                          const Icon(Icons.picture_as_pdf, color: Colors.red),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              provider.uploadedFile!.name,
                              style: JasaraTextStyles.primaryText400,
                              overflow: TextOverflow.ellipsis,
                            ),
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
