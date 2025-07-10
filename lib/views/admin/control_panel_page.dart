import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../widgets/utils/app_palette.dart';
import '../../widgets/utils/app_textStyles.dart';
import '../../widgets/utils/app_text_field.dart';

class ControlPanelPage extends StatefulWidget {
  const ControlPanelPage({super.key});

  @override
  State<ControlPanelPage> createState() => _ControlPanelPageState();
}

class _ControlPanelPageState extends State<ControlPanelPage> {
  final List<CriteriaData> _criteriaList = [CriteriaData()];

  void _addCriteria() {
    setState(() => _criteriaList.add(CriteriaData()));
  }

  void _removeCriteria(int index) {
    setState(() => _criteriaList.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JasaraPalette.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter Criteria for AI Assessment",
              style: JasaraTextStyles.primaryText500.copyWith(
                fontSize: 22,
                color: JasaraPalette.dark2,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _criteriaList.length,
              itemBuilder: (context, index) {
                return _buildCriteriaCard(index);
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _addCriteria,
                  child: const Text("Add a new criteria"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCriteriaCard(int index) {
    final data = _criteriaList[index];
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: "Criteria (${index + 1}) (max 1000 chars)",
              controller: data.criteriaController,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: "Text Instructions (max 2500 chars)",
              controller: data.instructionController,
            ),
            const SizedBox(height: 12),
            Row(
              children: List.generate(3, (fileIndex) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: _buildFilePicker(
                      label: "Instructions PDF ${fileIndex + 1}",
                      file: data.files[fileIndex],
                      onFilePicked: (file) {
                        setState(() => data.files[fileIndex] = file);
                      },
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _removeCriteria(index),
                  child: const Text("Remove Criteria"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // Save logic here
                    debugPrint("Saved criteria ${index + 1}");
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePicker({
    required String label,
    required File? file,
    required ValueChanged<File?> onFilePicked,
  }) {
    return InkWell(
      onTap: () async {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
          withData: false,
        );
        if (result != null && result.files.single.size <= 500 * 1024) {
          final path = result.files.single.path;
          if (path != null) {
            onFilePicked(File(path));
          }
        }
      },
      child: Container(
        height: 80,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: JasaraPalette.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: JasaraPalette.primary.withOpacity(0.4)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.picture_as_pdf, color: Colors.red.shade400),
            const SizedBox(height: 4),
            Text(
              file != null ? file.path.split("/").last : label,
              style: JasaraTextStyles.primaryText400,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class CriteriaData {
  final TextEditingController criteriaController = TextEditingController();
  final TextEditingController instructionController = TextEditingController();
  final List<File?> files = [null, null, null];

  void dispose() {
    criteriaController.dispose();
    instructionController.dispose();
  }
}
