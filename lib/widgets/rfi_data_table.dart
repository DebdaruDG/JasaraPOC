import 'package:flutter/material.dart';
import '../models/rfi_model.dart';
import 'rfi_result_indicator.dart';
import 'popup_action_menu.dart';

class RFIDataTable extends StatelessWidget {
  final List<RFIModel> rfis;
  const RFIDataTable({super.key, required this.rfis});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 32,
      headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
      columns: const [
        DataColumn(label: Text('Project')),
        DataColumn(label: Text('AI Comments')),
        DataColumn(label: Text('RFI Files')),
        DataColumn(label: Text('Result')),
        DataColumn(label: Text('Actions')),
      ],
      rows:
          rfis.map((rfi) {
            return DataRow(
              cells: [
                DataCell(Text(rfi.title)),
                DataCell(Text(rfi.comment)),
                DataCell(
                  InkWell(
                    onTap: () => debugPrint("Opening: ${rfi.fileUrl}"),
                    child: Text(
                      rfi.fileName,
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                DataCell(RFIResultIndicator(rfi: rfi)),
                DataCell(
                  PopupActionMenu(
                    onEdit: () => debugPrint('Edit: ${rfi.title}'),
                    onArchive: () => debugPrint('Archive: ${rfi.title}'),
                    onDelete: () => debugPrint('Delete: ${rfi.title}'),
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }
}
