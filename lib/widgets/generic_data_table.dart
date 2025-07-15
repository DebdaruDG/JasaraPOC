import 'package:flutter/material.dart';

class GenericDataTable extends StatelessWidget {
  final List<String> columnTitles;
  final List<List<Widget>> rowData;

  const GenericDataTable({
    super.key,
    required this.columnTitles,
    required this.rowData,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
      columns:
          columnTitles.map((title) => DataColumn(label: Text(title))).toList(),
      rows:
          rowData
              .map(
                (cells) => DataRow(
                  cells: cells.map((cell) => DataCell(cell)).toList(),
                ),
              )
              .toList(),
    );
  }
}
