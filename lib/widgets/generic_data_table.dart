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
    final columnCount = columnTitles.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final columnWidth = totalWidth / columnCount;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: totalWidth),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
              horizontalMargin: 0,
              columnSpacing: 0,
              dataRowMinHeight: 60,
              dataRowMaxHeight: 72,
              headingTextStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              columns:
                  columnTitles
                      .map(
                        (title) => DataColumn(
                          label: SizedBox(
                            width: columnWidth,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                title,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
              rows:
                  rowData
                      .map(
                        (rowCells) => DataRow(
                          cells:
                              rowCells
                                  .map(
                                    (cell) => DataCell(
                                      SizedBox(
                                        width: columnWidth,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          child: cell,
                                        ),
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
