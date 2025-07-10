// home_page.dart
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../../core/services/file_service.dart';
import '../../widgets/utils/app_button.dart';
import '../../widgets/utils/app_palette.dart';
import '../../widgets/utils/app_textStyles.dart';

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

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: JasaraPalette.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String key, List<String> items) {
    return DropdownButtonFormField<String>(
      value: _controllers[key]!.text.isEmpty ? null : _controllers[key]!.text,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: JasaraPalette.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
      ),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (value) {
        setState(() {
          _controllers[key]!.text = value!;
        });
      },
    );
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
        strokeWidth: 2,
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
                        Icons.upload_file,
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
      _buildTextField("Opportunity Code", _controllers['opportunityCode']!),
      _buildTextField("Opportunity Name", _controllers['opportunityName']!),
      _buildTextField("Date", _controllers['date']!),
      _buildTextField("Proposal Manager", _controllers['proposalManager']!),
      _buildTextField(
        "Brief Description of Work",
        _controllers['description']!,
      ),
      _buildDropdown("Project Type", 'projectType', [
        'Internal',
        'Client-Based',
        'R&D',
      ]),
      _buildTextField("Client Name", _controllers['clientName']!),
      _buildDropdown("Client Type", 'clientType', [
        'Government',
        'Private',
        'NGO',
      ]),
      _buildDropdown("Relationship with Client", 'relationship', [
        'Excellent',
        'Good',
        'Neutral',
        'Poor',
      ]),
      _buildTextField("Submission Date", _controllers['submissionDate']!),
      _buildTextField("Bidding Criteria", _controllers['biddingCriteria']!),
      _buildDropdown("Is it a targeted project?", 'isTargeted', ['Yes', 'No']),
      _buildTextField("Comments", _controllers['comments']!),
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
                "Attach the RPF Document and Fill the Go/No-Go Form ",
                style: JasaraTextStyles.primaryText500.copyWith(
                  fontSize: 22,
                  color: JasaraPalette.dark2,
                ),
              ),
              const SizedBox(height: 16),
              _buildFileUploadField(),
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
