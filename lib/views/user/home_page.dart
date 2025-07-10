import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/services/file_service.dart';
import '../../widgets/utils/app_button.dart';
import '../../widgets/utils/app_palette.dart';
import '../../widgets/utils/app_textStyles.dart';
import '../../widgets/utils/app_text_field.dart';
import '../../widgets/utils/app_drop_down.dart';
import 'assessment_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
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

  String? finalDecision;
  File? uploadedFile;

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildFileUploadField() {
    return GestureDetector(
      onTap: () async {
        File? file = await FileService.pickPDF();
        if (file != null) {
          setState(() {
            uploadedFile = file;
          });
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
            color: JasaraPalette.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child:
              uploadedFile == null
                  ? Column(
                    children: const [
                      Icon(
                        CupertinoIcons.upload_circle_fill,
                        size: 40,
                        color: JasaraPalette.primary,
                      ),
                      SizedBox(height: 8),
                      Text("Drag & Drop or Click to Upload PDF"),
                    ],
                  )
                  : Row(
                    children: [
                      const Icon(Icons.picture_as_pdf, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          uploadedFile!.path.split('/').last,
                          style: JasaraTextStyles.primaryText400,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    List<Widget> fields = [
      AppTextField(
        label: "Opportunity Code",
        controller: _controllers['opportunityCode']!,
      ),
      AppTextField(
        label: "Opportunity Name",
        controller: _controllers['opportunityName']!,
      ),
      AppTextField(label: "Date", controller: _controllers['date']!),
      AppTextField(
        label: "Proposal Manager",
        controller: _controllers['proposalManager']!,
      ),
      AppTextField(
        label: "Brief Description of Work",
        controller: _controllers['description']!,
      ),
      AppDropdown(
        label: "Project Type",
        dropdownKey: 'projectType',
        items: ['Internal', 'Client-Based', 'R&D'],
        controller: _controllers['projectType']!,
        onChanged: (value) {
          setState(() {
            _controllers['projectType']!.text = value!;
          });
        },
      ),
      AppTextField(
        label: "Client Name",
        controller: _controllers['clientName']!,
      ),
      AppDropdown(
        label: "Client Type",
        dropdownKey: 'clientType',
        items: ['Government', 'Private', 'NGO'],
        controller: _controllers['clientType']!,
        onChanged: (value) {
          setState(() {
            _controllers['clientType']!.text = value!;
          });
        },
      ),
      AppDropdown(
        label: "Relationship with Client",
        dropdownKey: 'relationship',
        items: ['Excellent', 'Good', 'Neutral', 'Poor'],
        controller: _controllers['relationship']!,
        onChanged: (value) {
          setState(() {
            _controllers['relationship']!.text = value!;
          });
        },
      ),
      AppTextField(
        label: "Submission Date",
        controller: _controllers['submissionDate']!,
      ),
      AppTextField(
        label: "Bidding Criteria",
        controller: _controllers['biddingCriteria']!,
      ),
      AppDropdown(
        label: "Is it a targeted project?",
        dropdownKey: 'isTargeted',
        items: ['Yes', 'No'],
        controller: _controllers['isTargeted']!,
        onChanged: (value) {
          setState(() {
            _controllers['isTargeted']!.text = value!;
          });
        },
      ),
      AppTextField(label: "Comments", controller: _controllers['comments']!),
    ];

    return Scaffold(
      backgroundColor: JasaraPalette.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Attach the RPF Document",
                style: JasaraTextStyles.primaryText500.copyWith(
                  fontSize: 22,
                  color: JasaraPalette.dark2,
                ),
              ),
              const SizedBox(height: 16),
              _buildFileUploadField(),
              const SizedBox(height: 16),
              Text(
                "Fill the Go/No-Go Form ",
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
                                    ? MediaQuery.of(context).size.width / 2 - 24
                                    : double.infinity,
                            child: field,
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 16),
              const Text(
                "Final Decision:",
                style: JasaraTextStyles.primaryText500,
              ),
              Row(
                children: [
                  Checkbox(
                    value: finalDecision == 'Go',
                    onChanged: (val) {
                      setState(() {
                        finalDecision = val! ? 'Go' : null;
                      });
                    },
                  ),
                  const Text("Go"),
                  Checkbox(
                    value: finalDecision == 'No Go',
                    onChanged: (val) {
                      setState(() {
                        finalDecision = val! ? 'No Go' : null;
                      });
                    },
                  ),
                  const Text("No Go"),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton2(
                    label: "Submit",
                    backgroundColor: JasaraPalette.primary,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssessmentPage(),
                        ),
                      );
                      if (_formKey.currentState!.validate()) {
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
  }
}
