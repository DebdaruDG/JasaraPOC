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
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final columnCount = columnTitles.length;
        final columnWidth = totalWidth / columnCount;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: totalWidth),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
              columns:
                  columnTitles
                      .map(
                        (title) => DataColumn(
                          label: SizedBox(
                            width: columnWidth,
                            child: Text(title),
                          ),
                        ),
                      )
                      .toList(),
              rows:
                  rowData
                      .map(
                        (cells) => DataRow(
                          cells:
                              cells
                                  .asMap()
                                  .entries
                                  .map(
                                    (entry) => DataCell(
                                      SizedBox(
                                        width: columnWidth,
                                        child: entry.value,
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      )
                      .toList(),
            ),
          ),
        );
      },
    );
  }
}
