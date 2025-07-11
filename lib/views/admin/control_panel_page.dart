import 'dart:developer' as console;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/criteria_provider.dart';
import '../../widgets/utils/app_palette.dart';
import '../../widgets/utils/app_textStyles.dart';
import '../../widgets/utils/app_text_field.dart';
import '../../widgets/utils/app_toast.dart';

class ControlPanelPage extends StatefulWidget {
  const ControlPanelPage({super.key});

  @override
  State<ControlPanelPage> createState() => _ControlPanelPageState();
}

class _ControlPanelPageState extends State<ControlPanelPage> {
  final List<CriteriaData> _criteriaList = [];

  void _addCriteria(CriteriaData data) {
    setState(() => _criteriaList.add(data));
  }

  @override
  void initState() {
    super.initState();
    final criteriaVM = Provider.of<CriteriaProvider>(context, listen: false);
    Future.delayed(
      Duration.zero,
      () async => await criteriaVM.fetchCriteriaList(),
    );
  }

  void _openCriteriaDialog({CriteriaData? initialData, int? editIndex}) {
    final CriteriaData data = initialData ?? CriteriaData();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color.fromARGB(255, 240, 247, 221),
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              editIndex == null ? 'Add Criteria' : 'Update Criteria',
              style: JasaraTextStyles.primaryText500.copyWith(
                fontSize: 20,
                color: JasaraPalette.dark2,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextField(
                    label: "Criteria (max 1000 chars)",
                    controller: data.criteriaController,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: data.instructionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: "Text Instructions (max 2500 chars)",
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
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final criteriaName = data.criteriaController.text.trim();
                  final textInstruction =
                      data.instructionController.text.trim();

                  if (criteriaName.isEmpty || textInstruction.isEmpty) {
                    JasaraToast.error(context, "Please fill all fields.");
                    return;
                  }

                  final provider = Provider.of<CriteriaProvider>(
                    context,
                    listen: false,
                  );

                  try {
                    await provider.createCriteriaBE(
                      criteriaName,
                      textInstruction,
                      pdf1: data.files[0],
                      pdf2: data.files[1],
                      pdf3: data.files[2],
                    );
                    await JasaraToast.success(
                      context,
                      "Criteria added successfully!",
                    );

                    if (editIndex != null) {
                      setState(() => _criteriaList[editIndex] = data);
                    } else {
                      _addCriteria(data);
                    }
                    Navigator.pop(context);
                  } catch (e) {
                    console.log('errors - $e');
                    JasaraToast.error(context, "Something went wrong!");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: JasaraPalette.primary,
                  foregroundColor: JasaraPalette.white,
                ),
                child: const Text("Save"),
              ),
            ],
          ),
    );
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
              "AI Assessment Criteria's",
              style: JasaraTextStyles.primaryText500.copyWith(
                fontSize: 22,
                color: JasaraPalette.dark2,
              ),
            ),
            const SizedBox(height: 16),
            Consumer<CriteriaProvider>(
              builder: (context, criteriaVM, _) {
                final list = criteriaVM.criteriaListResponse;

                if (list.isEmpty) {
                  return const Center(child: Text("No Criteria Added Yet"));
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  separatorBuilder:
                      (context, index) => const Divider(
                        thickness: 0.8,
                        height: 10,
                        color: Colors.grey,
                      ),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return ListTile(
                      title: Text(item.title),
                      subtitle: Text(
                        item.textInstructions,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Optional: Handle edit logic
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // Optional: Handle delete logic
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: JasaraPalette.primary,
                    foregroundColor: JasaraPalette.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _openCriteriaDialog(),
                  child: const Text("Add a new criteria"),
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
