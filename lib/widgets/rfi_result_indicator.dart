import 'dart:developer' as console;
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../models/rfi_model.dart';
import 'utils/app_palette.dart';
import 'utils/app_textStyles.dart';

class RFIResultIndicator extends StatelessWidget {
  final RFIModel rfi;
  const RFIResultIndicator({super.key, required this.rfi});

  @override
  Widget build(BuildContext context) {
    console.log(
      'rfi.result :- ${rfi.result} \t rfi.percentage :- ${rfi.percentage}',
    );
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 6),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 20,
              lineWidth: 4.5,
              animation: true,
              percent: (rfi.percentage.toDouble() / 100).clamp(0.0, 1.0),
              center: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  "${rfi.percentage.toInt()}%",
                  style: JasaraTextStyles.primaryText500.copyWith(
                    fontSize: 13, // ✅ Reduced font size
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              progressColor: rfi.progressColor,
              backgroundColor: JasaraPalette.grey.withOpacity(0.2),
              circularStrokeCap: CircularStrokeCap.round,
            ),
            Text(
              rfi.result,
              style: JasaraTextStyles.primaryText500.copyWith(
                fontSize: 13, // ✅ Reduced font size
                fontWeight: FontWeight.w800,
                color: rfi.progressColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
