import 'dart:developer' as console;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/api/api_response.dart';
import '../../core/services/firebase/core_service.dart';
import '../../providers/criteria_provider.dart';
import '../../widgets/utils/app_palette.dart';
import '../../widgets/utils/app_textStyles.dart';
import '../../widgets/generic_data_table.dart';
import '../../widgets/popup_action_menu.dart';
import '../../widgets/rfi_stat_card.dart';
import '../../models/rfi_stat_model.dart';
import '../../widgets/utils/app_button.dart';
import '../../widgets/utils/app_text_field.dart';
import '../../widgets/utils/app_toast.dart';

import '../../widgets/view_pdf.dart';

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

  void _openCriteriaDialog({
    required BuildContext rootContext,
    CriteriaData? initialData,
    int? editIndex,
  }) {
    final CriteriaData data = initialData ?? CriteriaData();

    showDialog(
      context: rootContext,
      builder:
          (context) => Consumer<CriteriaProvider>(
            builder:
                (context, provider, child) => StatefulBuilder(
                  builder: (BuildContext context, StateSetter dialogSetState) {
                    return AlertDialog(
                      backgroundColor: JasaraPalette.white,
                      contentPadding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      title: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                editIndex == null
                                    ? 'Add Criteria'
                                    : 'Update Criteria',
                                style: JasaraTextStyles.primaryText500.copyWith(
                                  fontSize: 20,
                                  color: JasaraPalette.dark2,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              InkWell(
                                onTap: () => Navigator.pop(rootContext),
                                child: Icon(
                                  Icons.close,
                                  color: JasaraPalette.dark1,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      content: Container(
                        width:
                            MediaQuery.of(rootContext).size.width *
                            0.4, // Larger dialog width
                        margin: const EdgeInsets.all(12),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppTextField(
                                label: "Title",
                                controller: data.criteriaController,
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: data.instructionController,
                                maxLines: 10,
                                decoration: InputDecoration(
                                  labelText:
                                      "Text Instructions (max 2500 chars)",
                                  filled: true,
                                  fillColor: JasaraPalette.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 12.0,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: BorderSide(
                                      color: JasaraPalette.charcoalGrey,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: BorderSide(
                                      color: JasaraPalette.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Display list of attached files
                                  if (data.files.any((file) => file != null))
                                    Wrap(
                                      spacing: 8.0,
                                      runSpacing: 8.0,
                                      children:
                                          data.files
                                              .asMap()
                                              .entries
                                              .where(
                                                (entry) => entry.value != null,
                                              )
                                              .map((entry) {
                                                final index = entry.key;
                                                final file = entry.value!;
                                                return Chip(
                                                  label: Text(
                                                    data.fileNames[index] ??
                                                        (file.path ?? '')
                                                            .split("/")
                                                            .last,
                                                    style:
                                                        JasaraTextStyles
                                                            .primaryText400,
                                                  ),
                                                  deleteIcon: const Icon(
                                                    Icons.delete,
                                                    size: 18,
                                                    color: Colors.red,
                                                  ),
                                                  onDeleted: () {
                                                    dialogSetState(() {
                                                      data.files[index] = null;
                                                      data.fileNames[index] =
                                                          null;
                                                    });
                                                  },
                                                  backgroundColor:
                                                      JasaraPalette.white,
                                                  side: BorderSide(
                                                    color: JasaraPalette.primary
                                                        .withOpacity(0.4),
                                                  ),
                                                );
                                              })
                                              .toList(),
                                    ),
                                  const SizedBox(height: 8),
                                  // Attach Supporting Files button with wider appearance
                                  SizedBox(
                                    child: CustomButton2(
                                      padding: EdgeInsets.zero,
                                      label: "Attach Supporting Files",
                                      prefixIcon: const Icon(
                                        Icons.insert_drive_file,
                                        color: JasaraPalette.white,
                                        size: 20,
                                      ),
                                      backgroundColor: JasaraPalette.oceanBlue,
                                      height:
                                          50, // Increased height for visual emphasis
                                      onPressed: () async {
                                        if (data.files
                                                .where((file) => file != null)
                                                .length >=
                                            3) {
                                          JasaraToast.error(
                                            rootContext,
                                            "Maximum 3 files allowed.",
                                          );
                                          return;
                                        }
                                        final result = await FilePicker.platform
                                            .pickFiles(
                                              type: FileType.custom,
                                              allowedExtensions: ['pdf'],
                                              withData:
                                                  true, // Ensure bytes are available for web
                                            );
                                        if (result != null &&
                                            result.files.single.size <=
                                                500 * 1024) {
                                          final platformFile =
                                              result.files.single;
                                          dialogSetState(() {
                                            // Find the first null slot in files list
                                            final index = data.files.indexWhere(
                                              (file) => file == null,
                                            );
                                            if (index != -1) {
                                              String displayName =
                                                  platformFile.name;
                                              int counter = 1;
                                              final existingNames =
                                                  data.fileNames
                                                      .where(
                                                        (name) => name != null,
                                                      )
                                                      .toList();
                                              while (existingNames.contains(
                                                displayName,
                                              )) {
                                                final nameWithoutExtension =
                                                    platformFile.name
                                                        .split('.')
                                                        .first;
                                                final extension =
                                                    platformFile.name
                                                        .split('.')
                                                        .last;
                                                displayName =
                                                    '$nameWithoutExtension ($counter).$extension';
                                                counter++;
                                              }
                                              data.files[index] = platformFile;
                                              data.fileNames[index] =
                                                  displayName;
                                            }
                                          });
                                        } else if (result != null) {
                                          JasaraToast.error(
                                            rootContext,
                                            "File size exceeds 500KB limit.",
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      actionsAlignment: MainAxisAlignment.center,
                      actions: [
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 45,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: JasaraPalette.pinkishRed,
                                    foregroundColor: JasaraPalette.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(rootContext),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.close,
                                        size: 24,
                                        color: JasaraPalette.background,
                                      ),
                                      const SizedBox(width: 5),
                                      const Text("Cancel"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SizedBox(
                                height: 45,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final criteriaName =
                                        data.criteriaController.text.trim();
                                    final textInstruction =
                                        data.instructionController.text.trim();

                                    if (criteriaName.isEmpty ||
                                        textInstruction.isEmpty) {
                                      JasaraToast.error(
                                        rootContext,
                                        "Please fill all fields.",
                                      );
                                      return;
                                    }

                                    final provider =
                                        Provider.of<CriteriaProvider>(
                                          rootContext,
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
                                        rootContext,
                                        "Criteria added successfully!",
                                      );

                                      if (editIndex != null) {
                                        setState(
                                          () => _criteriaList[editIndex] = data,
                                        );
                                      } else {
                                        _addCriteria(data);
                                      }
                                      Navigator.pop(rootContext);
                                    } catch (e) {
                                      console.log('errors - $e');
                                      JasaraToast.error(
                                        rootContext,
                                        "Something went wrong!",
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: JasaraPalette.mintGreen,
                                    foregroundColor: JasaraPalette.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check,
                                        size: 24,
                                        color: JasaraPalette.background,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        provider.responseBodyModel.status ==
                                                Status.loading
                                            ? 'Saving...'
                                            : 'Save',
                                      ),
                                      const SizedBox(width: 15),
                                      if (provider.responseBodyModel.status ==
                                          Status.loading)
                                        SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: JasaraPalette.background,
                                            strokeWidth: 1.5,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Consumer<CriteriaProvider>(
        builder:
            (context, provider, child) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double width = constraints.maxWidth;
                        int crossAxisCount = width < 1024 ? 2 : 4;

                        final stats = [
                          RFIStatModel(
                            label: 'Total Criteria',
                            value: '15',
                            icon: Icons.list_alt,
                            gradientColors: [
                              JasaraPalette.indigoBlue,
                              JasaraPalette.primary,
                            ],
                          ),
                          RFIStatModel(
                            label: 'Active Criteria',
                            value: '15',
                            icon: Icons.check_circle,
                            gradientColors: [
                              JasaraPalette.aquaGreen,
                              JasaraPalette.skyBlue,
                            ],
                          ),
                          RFIStatModel(
                            label: 'Inactive Criteria',
                            value: '0',
                            icon: Icons.remove_circle,
                            gradientColors: [
                              JasaraPalette.primary,
                              JasaraPalette.indigoBlue,
                            ],
                          ),
                          RFIStatModel(
                            label: 'Archived Criteria',
                            value: '0',
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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisExtent: 120,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemBuilder:
                              (context, index) =>
                                  RFIStatCard(stat: stats[index]),
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
                            buttonWidth = 100;
                          } else if (screenWidth < 1024) {
                            buttonWidth = 140;
                          } else {
                            buttonWidth = 180;
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
                            height: 50,
                            width: buttonWidth,
                            backgroundColor: JasaraPalette.indigoBlue,
                            onPressed:
                                () => _openCriteriaDialog(rootContext: context),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: JasaraPalette.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Consumer<CriteriaProvider>(
                        builder: (context, criteriaVM, _) {
                          final list = criteriaVM.criteriaListResponse;

                          return Column(
                            children: [
                              GenericDataTable(
                                columnFlexes: [3, 3, 2, 1],
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
                                        Wrap(
                                          spacing: 6,
                                          runSpacing: 6,
                                          children:
                                              item.files.map((f) {
                                                return Material(
                                                  color:
                                                      JasaraPalette
                                                          .greyShade100,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                    onTap: () {
                                                      showPDFViewerDialog(
                                                        context,
                                                        f.name,
                                                        f.base64,
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 6,
                                                          ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .picture_as_pdf,
                                                            size: 18,
                                                            color: Colors.red,
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),

                                                          Flexible(
                                                            child: Text(
                                                              f.name,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                  ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 6,
                                                          ),
                                                          const Icon(
                                                            Icons.visibility,
                                                            size: 18,
                                                            color:
                                                                JasaraPalette
                                                                    .deepIndigo,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                        ),

                                        PopupActionMenu(
                                          onEdit: () => {},
                                          onArchive:
                                              () => debugPrint(
                                                'Archive: ${item.title}',
                                              ),
                                          onDelete: () async {
                                            final confirm = await showDialog<
                                              bool
                                            >(
                                              context: context,
                                              builder:
                                                  (_) => AlertDialog(
                                                    title: const Text(
                                                      'Delete Criteria',
                                                    ),
                                                    content: const Text(
                                                      'Are you sure you want to delete this criteria?',
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed:
                                                            () => Navigator.pop(
                                                              context,
                                                              false,
                                                            ),
                                                        child: const Text(
                                                          'Cancel',
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed:
                                                            () => Navigator.pop(
                                                              context,
                                                              true,
                                                            ),
                                                        child: const Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            );

                                            if (confirm == true) {
                                              try {
                                                await FirebaseService.deleteCriteria(
                                                  item.docId ?? '',
                                                );

                                                /// ✅ Refresh API after deletion
                                                await Provider.of<
                                                  CriteriaProvider
                                                >(
                                                  context,
                                                  listen: false,
                                                ).fetchCriteriaList();

                                                JasaraToast.success(
                                                  context,
                                                  "Criteria deleted successfully.",
                                                );
                                              } catch (e) {
                                                console.log(
                                                  "Error deleting: $e",
                                                );
                                                JasaraToast.error(
                                                  context,
                                                  "Failed to delete the criteria.",
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ];
                                    }).toList(),
                              ),
                              if (list.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("No Criteria Added Yet !"),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}

class CriteriaData {
  final TextEditingController criteriaController = TextEditingController();
  final TextEditingController instructionController = TextEditingController();
  final List<PlatformFile?> files = [null, null, null];
  final List<String?> fileNames = [null, null, null];

  void dispose() {
    criteriaController.dispose();
    instructionController.dispose();
  }
}

void showPDFViewerDialog(
  BuildContext context,
  String fileName,
  String base64PDF,
) {
  showDialog(
    context: context,
    builder:
        (ctx) => AlertDialog(
          contentPadding: const EdgeInsets.all(8),
          insetPadding: const EdgeInsets.all(20),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$fileName ",
                style: JasaraTextStyles.primaryText500.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.8,
            child: PDFViewerWeb(base64PDF: base64PDF),
          ),
        ),
  );
}
