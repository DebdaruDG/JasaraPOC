import 'package:flutter/material.dart';
import 'utils/app_palette.dart';

class GenericDataTable extends StatelessWidget {
  final List<String> columnTitles;
  final List<List<Widget>> rowData;
  final List<double>? columnFlexes; // ✅ Optional parameter
  final Color headingRowColor;
  final TextAlign? headerTextAlign;

  const GenericDataTable({
    super.key,
    required this.columnTitles,
    required this.rowData,
    this.columnFlexes, // ✅ Not required
    this.headingRowColor = JasaraPalette.white,
    this.headerTextAlign,
  });

  @override
  Widget build(BuildContext context) {
    final columnCount = columnTitles.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;

        // ✅ If custom flexes provided, use them
        final defaultFlexes = List<double>.filled(columnCount, 1);
        final usedFlexes = columnFlexes ?? defaultFlexes;
        final totalFlex = usedFlexes.fold(0, (a, b) => int.parse('${a + b}'));

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: totalWidth),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(headingRowColor),
              border: TableBorder.symmetric(
                borderRadius: BorderRadius.circular(12),
              ),
              horizontalMargin: 0,
              columnSpacing: 0,
              dataRowMinHeight: 60,
              dataRowMaxHeight: 72,
              headingTextStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              columns: List.generate(columnCount, (index) {
                final colWidth = (usedFlexes[index] / totalFlex) * totalWidth;
                return DataColumn(
                  label: SizedBox(
                    width: colWidth,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        columnTitles[index],
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }),
              rows:
                  rowData.map((rowCells) {
                    return DataRow(
                      cells: List.generate(rowCells.length, (index) {
                        final colWidth =
                            (usedFlexes[index] / totalFlex) * totalWidth;
                        return DataCell(
                          SizedBox(
                            width: colWidth,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Center(child: rowCells[index]),
                            ),
                          ),
                        );
                      }),
                    );
                  }).toList(),
            ),
          ),
        );
      },
    );
  }
}
