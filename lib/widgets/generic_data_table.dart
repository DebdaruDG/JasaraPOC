import 'package:flutter/material.dart';
import 'utils/app_palette.dart';

class GenericDataTable extends StatelessWidget {
  final List<String> columnTitles;
  final List<List<Widget>> rowData;
  final List<double>? columnFlexes;
  final List<TextAlign>? columnTextAligns; // ✅ NEW
  final Color headingRowColor;
  final TextAlign? headerTextAlign; // Optional default header align
  final TableBorder? tableborder;

  const GenericDataTable({
    super.key,
    required this.columnTitles,
    required this.rowData,
    this.columnFlexes,
    this.columnTextAligns, // ✅ NEW
    this.headingRowColor = JasaraPalette.white,
    this.headerTextAlign,
    this.tableborder,
  });

  @override
  Widget build(BuildContext context) {
    final columnCount = columnTitles.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final defaultFlexes = List<double>.filled(columnCount, 1);
        final usedFlexes = columnFlexes ?? defaultFlexes;
        final totalFlex = usedFlexes.fold(0, (a, b) => (a + b).toInt());

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: totalWidth),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(headingRowColor),
              border:
                  tableborder ??
                  TableBorder.symmetric(
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
                final align =
                    columnTextAligns?[index] ??
                    headerTextAlign ??
                    TextAlign.center;

                return DataColumn(
                  label: SizedBox(
                    width: colWidth,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        columnTitles[index],
                        overflow: TextOverflow.ellipsis,
                        textAlign: align,
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
                        final align =
                            columnTextAligns?[index] ?? TextAlign.center;

                        return DataCell(
                          SizedBox(
                            width: colWidth,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Align(
                                alignment: _getAlignmentFromTextAlign(align),
                                child: rowCells[index],
                              ),
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

  /// Helper to convert TextAlign to Alignment for proper Align widget usage
  Alignment _getAlignmentFromTextAlign(TextAlign align) {
    switch (align) {
      case TextAlign.left:
        return Alignment.centerLeft;
      case TextAlign.right:
        return Alignment.centerRight;
      case TextAlign.center:
      default:
        return Alignment.center;
    }
  }
}
