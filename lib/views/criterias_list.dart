import 'dart:developer' as console;
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/criteria_provider.dart';
import '../widgets/utils/app_palette.dart';
import '../widgets/utils/app_textStyles.dart';
import '../widgets/generic_data_table.dart';
import '../widgets/popup_action_menu.dart';
import '../widgets/rfi_stat_card.dart';
import '../models/rfi_stat_model.dart';
import '../widgets/utils/app_button.dart';
import '../widgets/utils/app_text_field.dart';
import '../widgets/utils/app_toast.dart';
// import 'dart:html' as html;

class CriteriasList extends StatefulWidget {
  const CriteriasList({super.key});

  @override
  State<CriteriasList> createState() => _CriteriasListState();
}

class _CriteriasListState extends State<CriteriasList> {
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                double width = constraints.maxWidth;
                int crossAxisCount = width < 1024 ? 2 : 4;

                final stats = [
                  RFIStatModel(
                    label: 'Total Criteria',
                    value: '108',
                    icon: Icons.list,
                    gradientColors: [
                      JasaraPalette.indigoBlue,
                      JasaraPalette.primary,
                    ],
                  ),
                  RFIStatModel(
                    label: 'Active Criteria',
                    value: '78',
                    icon: Icons.check_circle,
                    gradientColors: [
                      JasaraPalette.aquaGreen,
                      JasaraPalette.skyBlue,
                    ],
                  ),
                  RFIStatModel(
                    label: 'Inactive Criteria',
                    value: '30',
                    icon: Icons.cancel,
                    gradientColors: [
                      JasaraPalette.primary,
                      JasaraPalette.indigoBlue,
                    ],
                  ),
                  RFIStatModel(
                    label: 'Archived Criteria',
                    value: '12',
                    icon: Icons.archive,
                    gradientColors: [
                      JasaraPalette.skyBlue,
                      JasaraPalette.aquaGreen,
                    ],
                  ),
                ];

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
                    buttonWidth = 140;
                  } else if (screenWidth < 1024) {
                    buttonWidth = 180;
                  } else {
                    buttonWidth = 220;
                  }

                  return CustomButton2(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: Icon(
                        Icons.add,
                        color: JasaraPalette.background,
                        size: 20,
                      ),
                    ),
                    label: "Add Criteria",
                    width: buttonWidth,
                    backgroundColor: JasaraPalette.indigoBlue,
                    onPressed: () => _openCriteriaDialog(),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Consumer<CriteriaProvider>(
              builder: (context, criteriaVM, _) {
                final list = criteriaVM.criteriaListResponse;

                if (list.isEmpty) {
                  return const Center(child: Text("No Criteria Added Yet"));
                }

                return GenericDataTable(
                  columnTitles: const [
                    'Title',
                    'Instructions',
                    'Supporting Files',
                    '',
                  ],
                  rowData:
                      list.map((item) {
                        return [
                          Text(item.title),
                          Text(
                            item.textInstructions,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'file_01.png, file_02.png',
                            style: const TextStyle(color: Colors.blue),
                          ),
                          PopupActionMenu(
                            onEdit: () => {},
                            onArchive:
                                () => debugPrint('Archive: ${item.title}'),
                            onDelete: () => debugPrint('Delete: ${item.title}'),
                          ),
                        ];
                      }).toList(),
                );
              },
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
