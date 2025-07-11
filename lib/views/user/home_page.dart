import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../widgets/utils/app_button.dart';
import '../../widgets/utils/app_palette.dart';
import '../../widgets/utils/app_textStyles.dart';
import '../../widgets/utils/app_text_field.dart';
import '../../widgets/utils/app_drop_down.dart';
import 'assessment_page.dart';

// FileService with Drag-and-Drop Support
class FileService {
  // Pick PDF via file picker (tap/click)
  static Future<File?> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  // Handle dropped files (for drag-and-drop)
  static Future<File?> handleDroppedFiles(List<dynamic> droppedFiles) async {
    if (droppedFiles.isEmpty) return null;

    for (var file in droppedFiles) {
      if (file is PlatformFile) {
        // Web or desktop with file_picker
        if (file.extension?.toLowerCase() == 'pdf' && file.path != null) {
          return File(file.path!);
        }
      } else if (file is String) {
        // Desktop path from drag_and_drop_files or similar
        if (file.toLowerCase().endsWith('.pdf')) {
          return File(file);
        }
      }
    }
    return null;
  }
}

// HomePageProvider for State Management
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
  };
  String? _finalDecision;
  File? _uploadedFile;
  bool _isDragOver = false;

  Map<String, TextEditingController> get controllers => _controllers;
  String? get finalDecision => _finalDecision;
  File? get uploadedFile => _uploadedFile;
  bool get isDragOver => _isDragOver;

  void setFinalDecision(String? value) {
    _finalDecision = value;
    notifyListeners();
  }

  Future<void> setUploadedFile(File? file) async {
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              label: "Opportunity Code",
              controller: provider.controllers['opportunityCode']!,
            ),
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
            AppDropdown(
              label: "Project Type",
              dropdownKey: 'projectType',
              items: ['Internal', 'Client-Based', 'R&D'],
              controller: provider.controllers['projectType']!,
              onChanged: (value) {
                provider.controllers['projectType']!.text = value!;
              },
            ),
            AppTextField(
              label: "Client Name",
              controller: provider.controllers['clientName']!,
            ),
            AppDropdown(
              label: "Client Type",
              dropdownKey: 'clientType',
              items: ['Government', 'Private', 'NGO'],
              controller: provider.controllers['clientType']!,
              onChanged: (value) {
                provider.controllers['clientType']!.text = value!;
              },
            ),
            AppDropdown(
              label: "Relationship with Client",
              dropdownKey: 'relationship',
              items: ['Excellent', 'Good', 'Neutral', 'Poor'],
              controller: provider.controllers['relationship']!,
              onChanged: (value) {
                provider.controllers['relationship']!.text = value!;
              },
            ),
            AppTextField(
              label: "Submission Date",
              controller: provider.controllers['submissionDate']!,
            ),
            AppTextField(
              label: "Bidding Criteria",
              controller: provider.controllers['biddingCriteria']!,
            ),
            AppDropdown(
              label: "Is it a targeted project?",
              dropdownKey: 'isTargeted',
              items: ['Yes', 'No'],
              controller: provider.controllers['isTargeted']!,
              onChanged: (value) {
                provider.controllers['isTargeted']!.text = value!;
              },
            ),
            AppTextField(
              label: "Comments",
              controller: provider.controllers['comments']!,
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
                    // const Text(
                    //   "Final Decision:",
                    //   style: JasaraTextStyles.primaryText500,
                    // ),
                    // Row(
                    //   children: [
                    //     Checkbox(
                    //       value: provider.finalDecision == 'Go',
                    //       onChanged: (val) {
                    //         provider.setFinalDecision(val! ? 'Go' : null);
                    //       },
                    //     ),
                    //     const Text("Go"),
                    //     Checkbox(
                    //       value: provider.finalDecision == 'No Go',
                    //       onChanged: (val) {
                    //         provider.setFinalDecision(val! ? 'No Go' : null);
                    //       },
                    //     ),
                    //     const Text("No Go"),
                    //   ],
                    // ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton2(
                          label: "Submit",
                          backgroundColor: JasaraPalette.primary,
                          onPressed:
                          // provider.uploadedFile == null
                          //     ? null
                          // :
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AssessmentPage(),
                              ),
                            );
                            if (formKey.currentState!.validate()) {
                              print("Form Submitted");
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
      onLeave: (data) {
        provider.setDragOver(false);
      },
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
            File? file = await FileService.pickPDF();
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
                            // Drag & Drop or
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
                              provider.uploadedFile!.path.split('/').last,
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
