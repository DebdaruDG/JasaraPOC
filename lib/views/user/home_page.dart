import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
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
      ),
    );
  }

  Widget _buildDropdown(String label, String key, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
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
            items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
        onChanged: (value) {
          setState(() {
            _controllers[key]!.text = value!;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JasaraPalette.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Attach the RPF Document\nAnd Fill the Go/No-Go Form ",
                  style: JasaraTextStyles.primaryText500.copyWith(
                    fontSize: 22,
                    color: JasaraPalette.dark2,
                  ),
                ),
              ),
              _buildTextField(
                "Opportunity Code",
                _controllers['opportunityCode']!,
              ),
              _buildTextField(
                "Opportunity Name",
                _controllers['opportunityName']!,
              ),
              _buildTextField("Date", _controllers['date']!),
              _buildTextField(
                "Proposal Manager",
                _controllers['proposalManager']!,
              ),
              const SizedBox(height: 16),
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
              _buildTextField(
                "Submission Date",
                _controllers['submissionDate']!,
              ),
              _buildTextField(
                "Bidding Criteria",
                _controllers['biddingCriteria']!,
              ),
              _buildDropdown("Is it a targeted project?", 'isTargeted', [
                'Yes',
                'No',
              ]),
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
              _buildTextField("Comments", _controllers['comments']!),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton2(
                    label: "Submit",
                    backgroundColor: JasaraPalette.primary,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Handle form submission
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
